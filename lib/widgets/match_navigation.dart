import 'package:flutter/material.dart';

class MatchNavigation extends StatelessWidget {
  const MatchNavigation({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFF0E7E9))),
    ),
    child: const Row(
      children: [
        _NavigationItem(
          icon: Icons.explore_rounded,
          label: 'Ontdek',
          selected: true,
        ),
        _NavigationItem(icon: Icons.favorite_outline_rounded, label: 'Likes'),
        _NavigationItem(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Chats',
        ),
        _NavigationItem(icon: Icons.person_outline_rounded, label: 'Profiel'),
      ],
    ),
  );
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });
  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      selected: selected,
      child: TextButton(
        // Workshop 1: enkel de UI; navigatie volgt later.
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: selected
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF93868F),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}
