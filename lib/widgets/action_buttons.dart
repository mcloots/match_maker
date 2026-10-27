import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _ActionButton(
        label: 'Weigeren',
        icon: Icons.close_rounded,
        color: Color(0xFFE36B67),
      ),
      SizedBox(width: 28),
      _ActionButton(
        label: 'Liken',
        icon: Icons.favorite_rounded,
        color: Colors.white,
        primary: true,
      ),
    ],
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.primary = false,
  });
  final String label;
  final IconData icon;
  final Color color;
  final bool primary;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: primary ? const Color(0x40E94B78) : const Color(0x0F302531),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: CircleAvatar(
      radius: primary ? 35 : 31,
      backgroundColor: primary ? const Color(0xFFE94B78) : Colors.white,
      child: IconButton(
        tooltip: label,
        iconSize: primary ? 32 : 34,
        color: color,
        // Statische UI: likes, weigeringen en matches volgen later.
        onPressed: () {},
        icon: Icon(icon),
      ),
    ),
  );
}
