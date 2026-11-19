import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/avatar_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(child: AvatarImage(asset: profilePhoto, radius: 60)),
        const SizedBox(height: 12),
        Text(fullName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(jobTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 16),
        _Section(
          icon: Icons.person,
          title: 'Profil',
          child: const Text(aboutMe),
        ),
        _Section(
          icon: Icons.school,
          title: 'Formation',
          child: Column(
            children: [
              for (final e in educations)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.degree),
                  subtitle: Text('${e.school}\n${e.period}'),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
        _Section(
          icon: Icons.work,
          title: 'Expériences',
          child: Column(
            children: [
              for (final x in experiences)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(x.title),
                  subtitle: Text('${x.place} • ${x.period}\n${x.description}'),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
        _Section(
          icon: Icons.code,
          title: 'Compétences techniques',
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [for (final s in technicalSkills) Chip(label: Text(s))],
          ),
        ),
        _Section(
          icon: Icons.language,
          title: 'Langues',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final l in languages) Text('• $l')],
          ),
        ),
        _Section(
          icon: Icons.favorite,
          title: 'Centres d\'intérêt',
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [for (final i in interests) Chip(label: Text(i))],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _Section({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
