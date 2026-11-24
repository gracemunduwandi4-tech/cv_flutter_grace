import 'package:flutter/material.dart';

import '../models/membre.dart';
import '../services/api_service.dart';
import '../widgets/network_avatar.dart';

/// Affiche un membre (appel GET /famille-membres/{id}).
class MembreDetailPage extends StatelessWidget {
  final int id;
  const MembreDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du membre')),
      body: FutureBuilder<Membre>(
        future: ApiService.getMembre(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('${snap.error}', textAlign: TextAlign.center),
            ));
          }
          final m = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: NetworkAvatar(url: m.imageUrl, radius: 70)),
              const SizedBox(height: 16),
              Text(m.nomComplet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                        leading: const Icon(Icons.family_restroom),
                        title: const Text('Lien de parenté'),
                        subtitle: Text(m.parente)),
                    ListTile(
                        leading: const Icon(Icons.place),
                        title: const Text('Lieu de naissance'),
                        subtitle: Text(m.lieuNaissance)),
                    ListTile(
                        leading: const Icon(Icons.cake),
                        title: const Text('Date de naissance'),
                        subtitle: Text(m.dateNaissance)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
