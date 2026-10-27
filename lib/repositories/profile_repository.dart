import '../models/profile.dart';

/// Lokale voorbeeldgegevens; later kan deze repository een service gebruiken.
class ProfileRepository {
  const ProfileRepository();

  List<Profile> getProfiles() => const [alex, noor, sam, lina];

  // Fictieve volwassen profielen voor de mini-challenge.
  static const alex = Profile(
    name: 'Alex',
    age: 23,
    location: 'Antwerpen · 3 km',
    imageAsset: 'assets/images/alex.jpg',
    interests: ['Koffie', 'Reizen', 'Muziek'],
  );
  static const noor = Profile(
    name: 'Noor',
    age: 24,
    location: 'Gent · 8 km',
    imageAsset: 'assets/images/noor.jpg',
    interests: ['Fotografie', 'Koken', 'Wandelen'],
  );
  static const sam = Profile(
    name: 'Sam',
    age: 25,
    location: 'Mechelen · 12 km',
    imageAsset: 'assets/images/sam.jpg',
    interests: ['Sport', 'Films', 'Reizen'],
  );
  static const lina = Profile(
    name: 'Lina',
    age: 24,
    location: 'Leuven · 6 km',
    imageAsset: 'assets/images/lina.jpg',
    interests: ['Dansen', 'Koffie', 'Citytrips'],
  );
}
