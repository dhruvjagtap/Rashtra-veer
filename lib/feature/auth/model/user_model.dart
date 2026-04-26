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
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "dob": dob,
      "gender": gender,
      "bloodGroup": bloodGroup,
      "role": role,
      "fcmToken": fcmToken,
    };
  }
}
