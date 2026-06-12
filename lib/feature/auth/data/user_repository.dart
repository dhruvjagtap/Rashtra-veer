import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rashtraveer/feature/auth/model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  Future<void> createUser(UserModel user) async {
    final existing = await phoneExists(user.phone);

    if (existing) {
      throw Exception('Phone number already registered');
    }

    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<bool> phoneExists(String phone) async {
    final result = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<void> updatePaymentStatus(String uid, bool value) async {
    await _firestore.collection('users').doc(uid).update({
      'paymentCompleted': value,
    });
  }
}
