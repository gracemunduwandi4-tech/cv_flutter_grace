import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/membre.dart';

/// Erreur lisible, affichée à l'utilisateur.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Toutes les communications avec l'API passent par cette classe.
class ApiService {
  static const _timeout = Duration(seconds: 15);
  static const _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Lit la réponse JSON : renvoie "data" si success = true, sinon lève une erreur.
  static dynamic _handle(http.Response r) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(r.bodyBytes));
    } catch (_) {
      throw ApiException('Réponse invalide du serveur (code ${r.statusCode}).');
    }
    if (body is! Map || body['success'] != true) {
      var msg = (body is Map ? body['message'] : null)?.toString() ??
          'Erreur (code ${r.statusCode})';
      if (body is Map && body['errors'] is Map) {
        msg = '$msg\n${(body['errors'] as Map).values.join('\n')}';
      }
      throw ApiException(msg);
    }
    return body['data'];
  }

  /// Exécute une requête et transforme les erreurs réseau en messages clairs.
  static Future<T> _run<T>(Future<T> Function() action) async {
    const reseau = 'Impossible de joindre le serveur.\n'
        'Vérifiez : XAMPP (Apache + MySQL) démarré, le même Wi-Fi, '
        'et l\'adresse dans lib/config.dart.';
    try {
      return await action();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(reseau);
    } on SocketException {
      throw ApiException(reseau);
    } on http.ClientException {
      throw ApiException(reseau);
    }
  }

  // ---------------------------------------------------------------- Comptes

  static Future<Map<String, dynamic>> login(String email, String password) {
    return _run(() async {
      final r = await http
          .post(_uri('/accounts/login'),
              headers: _jsonHeaders,
              body: jsonEncode({'email': email, 'password': password}))
          .timeout(_timeout);
      return Map<String, dynamic>.from(_handle(r) as Map);
    });
  }

  static Future<void> register(String email, String password) {
    return _run(() async {
      final r = await http
          .post(_uri('/accounts/register'),
              headers: _jsonHeaders,
              body: jsonEncode({'email': email, 'password': password}))
          .timeout(_timeout);
      _handle(r);
    });
  }

  // ---------------------------------------------------------------- Famille

  /// GET /famille-membres : liste de tous les membres.
  static Future<List<Membre>> getMembres() {
    return _run(() async {
      final r = await http
          .get(_uri('/famille-membres'), headers: _jsonHeaders)
          .timeout(_timeout);
      final data = _handle(r) as List;
      return data
          .map((e) => Membre.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    });
  }

  /// GET /famille-membres/{id} : un seul membre.
  static Future<Membre> getMembre(int id) {
    return _run(() async {
      final r = await http
          .get(_uri('/famille-membres/$id'), headers: _jsonHeaders)
          .timeout(_timeout);
      return Membre.fromJson(Map<String, dynamic>.from(_handle(r) as Map));
    });
  }

  static Future<http.Response> _sendMultipart(
      Uri uri, Map<String, String> fields, File image) async {
    final req = http.MultipartRequest('POST', uri)..fields.addAll(fields);
    req.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamed = await req.send().timeout(const Duration(seconds: 30));
    return http.Response.fromStream(streamed);
  }

  /// POST /famille-membres : avec image (form-data) ou sans image (JSON).
  static Future<void> createMembre(Map<String, String> fields, File? image) {
    return _run(() async {
      final http.Response r;
      if (image != null) {
        r = await _sendMultipart(_uri('/famille-membres'), fields, image);
      } else {
        r = await http
            .post(_uri('/famille-membres'),
                headers: _jsonHeaders, body: jsonEncode(fields))
            .timeout(_timeout);
      }
      _handle(r);
    });
  }

  /// Sans nouvelle image : PUT en JSON (l'image actuelle est conservée).
  /// Avec nouvelle image : POST en form-data sur /famille-membres/{id}.
  static Future<void> updateMembre(
      int id, Map<String, String> fields, File? image) {
    return _run(() async {
      final http.Response r;
      if (image != null) {
        r = await _sendMultipart(_uri('/famille-membres/$id'), fields, image);
      } else {
        r = await http
            .put(_uri('/famille-membres/$id'),
                headers: _jsonHeaders, body: jsonEncode(fields))
            .timeout(_timeout);
      }
      _handle(r);
    });
  }

  /// DELETE /famille-membres/{id}
  static Future<void> deleteMembre(int id) {
    return _run(() async {
      final r = await http
          .delete(_uri('/famille-membres/$id'), headers: _jsonHeaders)
          .timeout(_timeout);
      _handle(r);
    });
  }
}
