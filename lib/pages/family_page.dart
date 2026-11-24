import 'package:flutter/material.dart';

import '../models/membre.dart';
import '../services/api_service.dart';
import '../widgets/network_avatar.dart';
import 'family_form_page.dart';
import 'membre_detail_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<Membre>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getMembres();
  }

  void _reload() {
    setState(() {
      _future = ApiService.getMembres();
    });
  }

  Future<void> _openForm([Membre? membre]) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FamilyFormPage(membre: membre)),
    );
    if (ok == true) _reload();
  }

  Future<void> _delete(Membre m) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(m.nomComplet),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ApiService.deleteMembre(m.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Membre supprimé')));
      _reload();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Membre>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    Text('${snap.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: _reload, child: const Text('Réessayer')),
                  ],
                ),
              ),
            );
          }
          final membres = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: () async {
              _reload();
              try {
                await _future;
              } catch (_) {}
            },
            child: membres.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 160),
                      Center(
                          child: Text(
                              'Aucun membre. Appuyez sur « Ajouter ».')),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                    itemCount: membres.length,
                    itemBuilder: (context, i) {
                      final m = membres[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: NetworkAvatar(url: m.imageUrl, radius: 30),
                          title: Text(m.nomComplet,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('Lien : ${m.parente}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MembreDetailPage(id: m.id)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Modifier',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(m),
                              ),
                              IconButton(
                                tooltip: 'Supprimer',
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => _delete(m),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}
