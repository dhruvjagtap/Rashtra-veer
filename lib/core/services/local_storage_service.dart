// lib/core/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rashtraveer/feature/auth/model/user_model.dart';

class LocalStorageService {
  static const uidKey = 'uid';
  static const onboardingKey = 'onboarding';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(uidKey, user.uid);

    await prefs.setBool(onboardingKey, user.onboardingCompleted ?? false);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
