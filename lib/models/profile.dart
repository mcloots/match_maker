class Profile {
  const Profile({
    required this.name,
    required this.age,
    required this.location,
    required this.imageAsset,
    required this.interests,
  });
  final String name;
  final int age;
  final String location;
  final String imageAsset;
  final List<String> interests;
}
