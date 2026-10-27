import 'package:flutter/material.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key});

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
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'match maker',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Voorkeuren',
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, size: 23),
        ),
        IconButton(
          tooltip: 'Mijn profiel',
          onPressed: () {},
          icon: const Icon(Icons.account_circle_outlined, size: 26),
        ),
      ],
    ),
  );
}
