import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/profile_data.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _tile(context, Icons.phone, 'Téléphone', phone,
            Uri(scheme: 'tel', path: phone)),
        _tile(context, Icons.email, 'E-mail', email,
            Uri(scheme: 'mailto', path: email)),
        _tile(context, Icons.location_on, 'Adresse', address,
            Uri.parse('geo:0,0?q=${Uri.encodeComponent(address)}')),
        _tile(context, Icons.business_center, 'LinkedIn', linkedinUrl,
            Uri.parse(linkedinUrl)),
        _tile(context, Icons.code, 'GitHub', githubUrl, Uri.parse(githubUrl)),
      ],
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label,
      String value, Uri uri) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => _open(context, uri),
      ),
    );
  }
}
