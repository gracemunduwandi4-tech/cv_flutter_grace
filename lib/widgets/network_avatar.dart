import 'package:flutter/material.dart';

/// Photo ronde chargée depuis Internet (ou icône si pas d'image).
class NetworkAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  const NetworkAvatar({super.key, this.url, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.person, size: radius, color: Colors.indigo);
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: url == null
          ? icon
          : ClipOval(
              child: Image.network(
                url!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => icon,
              ),
            ),
    );
  }
}
