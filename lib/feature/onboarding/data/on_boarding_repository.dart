// onboarding_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rashtraveer/feature/onboarding/model/on_boarding_profile_model.dart';

class OnboardingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProfile(UserProfile profile) async {
    await _firestore
        .collection('user_profiles')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection('user_profiles').doc(uid).get();

    if (!doc.exists) return null;

    return UserProfile.fromMap(doc.data()!);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection('user_profiles')
        .doc(profile.uid)
        .update(profile.toMap());
  }
}
