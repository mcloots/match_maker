class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.interests,
  });
  final String id;
  final String name;
  final int age;
  final String location;
  final String imageUrl;
  final List<String> interests;

  factory Profile.fromMap(String id, Map<String, dynamic> data) => Profile(
    id: id,
    name: data['name'] as String? ?? '',
    age: (data['age'] as num?)?.toInt() ?? 18,
    location: data['location'] as String? ?? '',
    imageUrl: data['imageUrl'] as String? ?? '',
    interests: List<String>.from(data['interests'] ?? []),
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'age': age,
    'location': location,
    'imageUrl': imageUrl,
    'interests': interests,
  };
}
