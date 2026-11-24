import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/membre.dart';
import '../services/api_service.dart';
import '../widgets/network_avatar.dart';

/// Formulaire d'ajout (membre == null) ou de modification d'un membre.
class FamilyFormPage extends StatefulWidget {
  final Membre? membre;
  const FamilyFormPage({super.key, this.membre});

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _postnom;
  late final TextEditingController _prenom;
  late final TextEditingController _lieu;
  late final TextEditingController _date;
  late final TextEditingController _parente;
  File? _newImage;
  bool _saving = false;

  bool get _isEdit => widget.membre != null;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    _nom = TextEditingController(text: m?.nom ?? '');
    _postnom = TextEditingController(text: m?.postnom ?? '');
    _prenom = TextEditingController(text: m?.prenom ?? '');
    _lieu = TextEditingController(text: m?.lieuNaissance ?? '');
    _date = TextEditingController(text: m?.dateNaissance ?? '');
    _parente = TextEditingController(text: m?.parente ?? '');
  }

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _date, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (picked == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucune photo sélectionnée')));
        return;
      }
      final size = await picked.length();
      if (!mounted) return;
      setState(() => _newImage = File(picked.path));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Photo choisie : ${(size / 1024).round()} Ko')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur photo : $e')));
    }
  }

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_date.text) ?? DateTime(2000);
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      _date.text = '${d.year}-${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final fields = {
      'nom': _nom.text.trim(),
      'postnom': _postnom.text.trim(),
      'prenom': _prenom.text.trim(),
      'lieu_naissance': _lieu.text.trim(),
      'date_naissance': _date.text.trim(),
      'parente': _parente.text.trim(),
    };
    try {
      if (_isEdit) {
        await ApiService.updateMembre(widget.membre!.id, fields, _newImage);
      } else {
        await ApiService.createMembre(fields, _newImage);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null;

  @override
  Widget build(BuildContext context) {
    final Widget preview;
    if (_newImage != null) {
      preview = ClipOval(
        child: Image.file(
          _newImage!,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (_, error, __) => CircleAvatar(
            radius: 55,
            child: Text('Image illisible\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 8)),
          ),
        ),
      );
    } else {
      preview = NetworkAvatar(url: widget.membre?.imageUrl, radius: 55);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Modifier le membre' : 'Ajouter un membre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(child: preview),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: Text(_newImage == null
                    ? 'Choisir une photo'
                    : 'Changer la photo'),
              ),
              const SizedBox(height: 8),
              _field(_nom, 'Nom', Icons.person),
              _field(_postnom, 'Postnom', Icons.person_outline),
              _field(_prenom, 'Prénom', Icons.badge),
              _field(_lieu, 'Lieu de naissance', Icons.place),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: _date,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance (AAAA-MM-JJ)',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  validator: _required,
                ),
              ),
              _field(_parente, 'Lien de parenté (ex. : Père, Frère)',
                  Icons.family_restroom),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEdit ? 'Enregistrer' : 'Ajouter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: _required,
      ),
    );
  }
}