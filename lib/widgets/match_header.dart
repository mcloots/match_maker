import 'package:flutter/material.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key, this.onProfile});

  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 16, 10),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.favorite_rounded, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "It's a Match!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          tooltip: 'Jouw profiel',
          onPressed: onProfile,
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
    ),
  );
}
