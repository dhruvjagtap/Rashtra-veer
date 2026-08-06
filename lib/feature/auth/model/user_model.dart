// lib/feature/auth/model/user_model.dart
class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final String dob;
  final String? gender;
  final String? bloodGroup;
  final String role;
  final String? fcmToken;
  final String? language;
  final DateTime? createdAt;
  final bool? onboardingCompleted;
  final bool? paymentCompleted;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dob,
    this.gender,
    this.bloodGroup,
    required this.role,
    this.fcmToken,
    this.language,
    this.createdAt,
    this.onboardingCompleted,
    this.paymentCompleted,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      dob: map['dob'] as String? ?? '',
      gender: map['gender'] as String?,
      bloodGroup: map['bloodGroup'] as String?,
      role: map['role'] as String? ?? 'user',
      fcmToken: map['fcmToken'] as String?,
      language: map['language'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,
      paymentCompleted: map['paymentCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'role': role,
      'fcmToken': fcmToken,
      'language': language,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'onboardingCompleted': onboardingCompleted ?? false,
      'paymentCompleted': paymentCompleted ?? false,
    };
  }

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? phone,
    String? dob,
    String? gender,
    String? bloodGroup,
    String? role,
    String? fcmToken,
    DateTime? createdAt,
    String? language,
    bool? onboardingCompleted,
    bool? paymentCompleted,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
    );
  }
}
