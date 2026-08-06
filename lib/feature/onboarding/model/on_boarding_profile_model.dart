// lib/feature/onboarding/model/on_boarding_profile_model.dart

class UserProfile {
  // onboarding1
  final String? uid;
  final double? height;
  final double? weight;
  final String? gender;
  final int? age;
  final double? bmi;
  // onboarding 2
  final bool? hasDisease;
  final String? selectedDisease;
  // onboarding 3
  final String? selectedGoal;
  // onboarding 4
  final String? selectedActivity;
  final String? selectedLifestyle;
  final int? selectedTime;
  // onboarding 5
  final String? selectedWorkout;
  // onboarding 6
  final String? selectedPlan;

  final int? currentStep;
  final int? totalSteps;
  final bool? completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.uid,
    required this.height,
    required this.weight,
    required this.gender,
    required this.age,
    required this.bmi,
    required this.hasDisease,
    required this.selectedDisease,
    required this.selectedGoal,
    required this.selectedActivity,
    required this.selectedLifestyle,
    required this.selectedTime,
    required this.selectedWorkout,
    required this.selectedPlan,
    this.currentStep,
    this.totalSteps,
    this.completed,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String?,
      height: map['height'] as double?,
      weight: map['weight'] as double?,
      gender: map['gender'] as String?,
      age: map['age'] as int? ?? 0,
      bmi: map['bmi'] as double?,
      hasDisease: map['hasDisease'] as bool?,
      selectedDisease: map['selectedDisease'] as String?,
      selectedGoal: map['selectedGoal'] as String?,
      selectedActivity: map['selectedActivity'] as String? ?? 'sedentary',
      selectedLifestyle: map['selectedLifestyle'] as String? ?? 'normal',
      selectedTime: map['selectedTime'] as int?,
      selectedWorkout: map['selectedWorkout'] as String?,
      selectedPlan: map['selectedPlan'] as String?,
      currentStep: map['currentStep'] as int? ?? 0,
      totalSteps: map['totalSteps'] as int? ?? 6,
      completed: map['completed'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'height': height,
      'weight': weight,
      'gender': gender,
      'age': age,
      'bmi': bmi,
      'hasDisease': hasDisease,
      'selectedDisease': selectedDisease,
      'selectedGoal': selectedGoal,
      'selectedActivity': selectedActivity,
      'selectedLifestyle': selectedLifestyle,
      'selectedTime': selectedTime,
      'selectedWorkout': selectedWorkout,
      'selectedPlan': selectedPlan,
      'currentStep': currentStep,
      'totalSteps': totalSteps,
      'completed': completed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? uid,
    double? height,
    double? weight,
    String? gender,
    int? age,
    double? bmi,
    bool? hasDisease,
    String? selectedDisease,
    String? selectedGoal,
    String? selectedActivity,
    String? selectedLifestyle,
    int? selectedTime,
    String? selectedWorkout,
    String? selectedPlan,
    int? currentStep,
    int? totalSteps,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      bmi: bmi ?? this.bmi,
      hasDisease: hasDisease ?? this.hasDisease,
      selectedDisease: selectedDisease ?? this.selectedDisease,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedLifestyle: selectedLifestyle ?? this.selectedLifestyle,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedWorkout: selectedWorkout ?? this.selectedWorkout,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
