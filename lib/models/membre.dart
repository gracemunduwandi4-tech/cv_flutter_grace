import '../config.dart';

/// Un membre de la famille tel que renvoyé par l'API.
class Membre {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // format AAAA-MM-JJ
  final String parente;
  final String? imageUrl;

  const Membre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  String get nomComplet => '$prenom $nom $postnom';

  factory Membre.fromJson(Map<String, dynamic> j) {
    String? img;
    final path = j['image']?.toString();
    if (path != null && path.isNotEmpty) {
      // On reconstruit l'adresse avec notre propre baseUrl, pour que
      // l'image soit joignable depuis le téléphone.
      img = '$baseUrl/$path';
    } else if (j['image_url'] != null) {
      img = j['image_url'].toString();
    }
    return Membre(
      id: int.parse(j['id'].toString()),
      nom: j['nom']?.toString() ?? '',
      postnom: j['postnom']?.toString() ?? '',
      prenom: j['prenom']?.toString() ?? '',
      lieuNaissance: j['lieu_naissance']?.toString() ?? '',
      dateNaissance: j['date_naissance']?.toString() ?? '',
      parente: j['parente']?.toString() ?? '',
      imageUrl: img,
    );
  }
}
