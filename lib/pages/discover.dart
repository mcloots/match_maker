import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import '../repositories/swipe_repository.dart';
import '../widgets/profile_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/match_header.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, this.likesOnly = false, this.onProfile});
  final bool likesOnly;
  final VoidCallback? onProfile;
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final SwipeRepository repository = SwipeRepository();
  // LIVE W2-07A: Keep the Firestore streams in state
  late final Stream<List<Profile>>? profilesStream = ProfileRepository()
      .watchProfiles();
  late final Stream<Map<String, bool>>? swipesStream = repository.watchSwipes();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Column(
        children: [
          MatchHeader(onProfile: widget.onProfile),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.likesOnly ? 'Jouw likes' : 'Een klik begint hier.',
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Profile>>(
              stream: profilesStream,
              builder: (context, profilesSnapshot) => StreamBuilder<Map<String, bool>>(
                stream: swipesStream,
                builder: (context, swipesSnapshot) {
                  // LIVE W2-07B: Check snapshots and filter profiles
                  if (profilesSnapshot.hasError || swipesSnapshot.hasError) {
                    return Center(child: Text("Laden is mislukt"));
                  }
                  if (!profilesSnapshot.hasData || !swipesSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final swipes = swipesSnapshot.data!;
                  final profiles = profilesSnapshot.data!
                      .where(
                        (profile) => widget.likesOnly
                            ? swipes[profile.id] == true
                            : !swipes.containsKey((profile.id)),
                      )
                      .toList();
                  if (profiles.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          widget.likesOnly
                              ? 'Nog geen likes. Swipe naar rechts bij Ontdek.'
                              : 'Geen nieuwe profielen. Vul je profiel in en laat iemand anders een account maken.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (widget.likesOnly) {
                    return ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(
                          Icons.favorite,
                          color: Color(0xFFE94B78),
                        ),
                        title: Text(
                          '${profiles[index].name}, ${profiles[index].age}',
                        ),
                        subtitle: Text(profiles[index].location),
                      ),
                    );
                  }
                  final profile = profiles.first;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      children: [
                        // confirmDismiss bewaart eerst in Firestore. De stream vervangt daarna de kaart.
                        Dismissible(
                          key: ValueKey(profile.id),
                          direction: isSaving
                              ? DismissDirection.none
                              : DismissDirection.horizontal,
                          background: const Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 60,
                            ),
                          ),
                          secondaryBackground: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 60,
                            ),
                          ),
                          // LIVE W2-08B: Connect the swipe gesture
                          confirmDismiss: (direction) async {
                            await _swipe(
                              profile,
                              direction == DismissDirection.startToEnd,
                            );
                            return false;
                          },
                          child: ProfileCard(profile: profile),
                        ),
                        const SizedBox(height: 22),
                        // LIVE W2-08C: Connect the action buttons
                        ActionButtons(
                          onReject: isSaving
                              ? null
                              : () => _swipe(profile, false),
                          onLike: isSaving ? null : () => _swipe(profile, true),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isSaving
                              ? 'Opslaan...'
                              : 'Links: overslaan · Rechts: liken',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // LIVE W2-08A: Save a swipe with loading and error handling
  Future<void> _swipe(Profile profile, bool liked) async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await repository.saveSwipe(profile, liked: liked);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Swipe niet opgeslagen.')));
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }
}
