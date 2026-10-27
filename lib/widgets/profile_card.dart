import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x263F2534),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        // Een minimumhoogte voor de foto, geen maximum voor de tekst.
        constraints: BoxConstraints(minHeight: constraints.maxWidth * 1.25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              // Card info
              Positioned.fill(
                child: Image.asset(
                  profile.imageAsset,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.4),
                  semanticLabel: 'Profielfoto van ${profile.name}',
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.35, 0.7, 1],
                      colors: [
                        Color(0x26000000),
                        Colors.transparent,
                        Color(0x66000000),
                        Color(0xE6191320),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCCFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Color(0xFF338563), size: 7),
                      SizedBox(width: 6),
                      Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  // Bovenaan blijft ruimte vrij voor de onlinebadge.
                  padding: const EdgeInsets.fromLTRB(24, 110, 24, 24),
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 17,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                profile.location,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Wrap laat interesses doorlopen als de kaart smaller wordt.
                        Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: profile.interests
                              .map(
                                (interest) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33FFFFFF),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0x55FFFFFF),
                                    ),
                                  ),
                                  child: Text(
                                    interest,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
