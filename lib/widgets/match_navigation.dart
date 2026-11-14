import 'package:flutter/material.dart';

class MatchNavigation extends StatelessWidget {
  const MatchNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: onSelected,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        label: 'Ontdek',
      ),
      NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'Likes'),
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline),
        label: 'Chats',
      ),
      NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profiel'),
    ],
  );
}
