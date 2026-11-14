import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile.dart';

class ProfileRepository {
  final profiles = FirebaseFirestore.instance.collection('profiles');
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // LIVE W2-03A: Watch the shared profiles
  Stream<List<Profile>> watchProfiles() {
    return profiles.snapshots().map(
      (snapshot) => snapshot.docs
      .where((doc) => doc.id != uid)
      .map((doc) => Profile.fromMap(doc.id, doc.data()))
      .toList()
    );
  }

  // LIVE W2-03B: Fetch your own profile once
  Future<Profile?> fetchMyProfile() async {
    final doc = await profiles.doc(uid).get();
    return doc.exists ? Profile.fromMap(doc.id, doc.data()!) : null;
  }

  // LIVE W2-03C: Save your own profile
  Future<void> saveProfile(Profile profile) async {
    return await profiles.doc(uid).set(profile.toMap());
  }
}
