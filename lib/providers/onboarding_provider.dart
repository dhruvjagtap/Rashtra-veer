import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/feature/onboarding/model/on_boarding_profile_model.dart';

final onboardingProvider = NotifierProvider<OnboardingNotifier, UserProfile>(
  OnboardingNotifier.new,
);

class OnboardingNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return UserProfile(
      uid: null,
      height: null,
      weight: null,
      gender: null,
      age: null,
      bmi: null,
      hasDisease: null,
      selectedDisease: null,
      selectedGoal: null,
      selectedActivity: null,
      selectedLifestyle: null,
      selectedTime: null,
      selectedWorkout: null,
      selectedPlan: null,
      currentStep: 1,
      totalSteps: 6,
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Screen 1
  void updateBasicInfo({
    String? uid,
    double? height,
    double? weight,
    String? gender,
    int? age,
    double? bmi,
  }) {
    state = state.copyWith(
      uid: uid,
      height: height,
      weight: weight,
      gender: gender,
      age: age,
      bmi: bmi,
      updatedAt: DateTime.now(),
    );
  }

  // Screen 2
  void updateDiseaseInfo({bool? hasDisease, String? selectedDisease}) {
    state = state.copyWith(
      hasDisease: hasDisease,
      selectedDisease: selectedDisease,
      updatedAt: DateTime.now(),
    );
  }

  // Screen 3
  void updateGoal(String goal) {
    state = state.copyWith(selectedGoal: goal, updatedAt: DateTime.now());
  }

  // Screen 4
  void updateLifestyle({String? activity, String? lifestyle, int? time}) {
    state = state.copyWith(
      selectedActivity: activity,
      selectedLifestyle: lifestyle,
      selectedTime: time,
      updatedAt: DateTime.now(),
    );
  }

  // Screen 5
  void updateWorkout(String? workout) {
    state = state.copyWith(selectedWorkout: workout, updatedAt: DateTime.now());
  }

  // Screen 6
  void updatePlan(String plan) {
    state = state.copyWith(selectedPlan: plan, updatedAt: DateTime.now());
  }

  void updateStep(int step) {
    state = state.copyWith(currentStep: step, updatedAt: DateTime.now());
  }

  void completeOnboarding() {
    state = state.copyWith(
      completed: true,
      currentStep: 6,
      updatedAt: DateTime.now(),
    );
  }

  void reset() {
    state = build();
  }
}
