import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/avatar_image.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: family.length,
      itemBuilder: (context, i) {
        final m = family[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AvatarImage(asset: m.photo, radius: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Lien : ${m.relation}'),
                      Text('Profession : ${m.job}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
