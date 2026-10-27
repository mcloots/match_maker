import 'package:flutter/material.dart';

import '../widgets/match_header.dart';
import '../repositories/profile_repository.dart';
import '../widgets/profile_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/match_navigation.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                MatchHeader(),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 14, 24, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Een klik begint hier.',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nieuwe mensen. Mooie connecties.',
                        style: TextStyle(color: Color(0xFF877A83)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ProfileCard(profile: ProfileRepository.lina),
                ),
                SizedBox(height: 22),
                ActionButtons(),
                SizedBox(height: 16),
                Text(
                  'Misschien is dit het begin van iets moois.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF877A83)),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const MatchNavigation(),
        ),
      ),
    ),
  );
}
