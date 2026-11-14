import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.onReject,
    required this.onLike,
  });
  final VoidCallback? onReject;
  final VoidCallback? onLike;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton.filledTonal(
        tooltip: 'Weigeren',
        iconSize: 34,
        onPressed: onReject,
        icon: const Icon(Icons.close_rounded),
      ),
      const SizedBox(width: 28),
      IconButton.filled(
        tooltip: 'Liken',
        iconSize: 34,
        onPressed: onLike,
        icon: const Icon(Icons.favorite_rounded),
      ),
    ],
  );
}
