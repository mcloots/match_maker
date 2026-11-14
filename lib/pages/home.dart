import 'package:flutter/material.dart';
import '../widgets/match_navigation.dart';
import 'discover.dart';
import 'profile.dart';

// LIVE W2-01: Build the first StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => buildHomeLayout(
    selectedIndex: selectedIndex,
    onSelected: (index) => setState(() => selectedIndex = index),
    onProfile: () => setState(() => selectedIndex = 3),
  );
}

// COPY: the layout is provided; connect it in W2-01.
Widget buildHomeLayout({
  required int selectedIndex,
  required ValueChanged<int> onSelected,
  required VoidCallback onProfile,
}) => Scaffold(
  body: SafeArea(
    child: IndexedStack(
      index: selectedIndex,
      children: [
        DiscoverPage(onProfile: onProfile),
        DiscoverPage(likesOnly: true, onProfile: onProfile),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Chats\nBerichten versturen komt in een volgende uitbreiding.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const ProfilePage(),
      ],
    ),
  ),
  bottomNavigationBar: MatchNavigation(
    selectedIndex: selectedIndex,
    onSelected: onSelected,
  ),
);
