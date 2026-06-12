import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/feature/auth/model/user_model.dart';

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateOnboarding(bool value) {
    if (state == null) return;

    state = state!.copyWith(onboardingCompleted: value);
  }

  void updatePayment(bool value) {
    if (state == null) return;

    state = state!.copyWith(paymentCompleted: value);
  }
}
