import 'package:flutter/material.dart';

/// Photo ronde. Affiche une icône si l'image est introuvable.
class AvatarImage extends StatelessWidget {
  final String asset;
  final double radius;
  const AvatarImage({super.key, required this.asset, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: Image.asset(
          asset,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.person, size: radius, color: Colors.indigo),
        ),
      ),
    );
  }
}
