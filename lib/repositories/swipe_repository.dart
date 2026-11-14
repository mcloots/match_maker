import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile.dart';

class SwipeRepository {
  // LIVE W2-03D: Select the current user swipe collection
  CollectionReference<Map<String, dynamic>> get swipes {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('swipes');
  }

  // LIVE W2-03E: Watch the saved choices
  Stream<Map<String, bool>> watchSwipes() {
    return swipes.snapshots().map(
      (snapshot) => {
        for (final doc in snapshot.docs) doc.id: doc.data()['liked'] == true,
      },
    );
  }

  // LIVE W2-03F: Save one choice per profile
  Future<void> saveSwipe(Profile profile, {required bool liked}) async {
    return await swipes.doc(profile.id).set({
      'liked': liked,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
