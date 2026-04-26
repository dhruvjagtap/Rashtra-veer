import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rashtraveer/feature/auth/model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class VerifyOtpScreen extends StatefulWidget {
  static const routeName = '/verify-otp';
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otp1 = TextEditingController();
  final TextEditingController _otp2 = TextEditingController();
  final TextEditingController _otp3 = TextEditingController();
  final TextEditingController _otp4 = TextEditingController();
  final TextEditingController _otp5 = TextEditingController();
  final TextEditingController _otp6 = TextEditingController();

  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  final FocusNode _focus3 = FocusNode();
  final FocusNode _focus4 = FocusNode();
  final FocusNode _focus5 = FocusNode();
  final FocusNode _focus6 = FocusNode();

  late String verificationId;
  late String firstName;
  late String lastName;
  late String phone;
  late String dob;
  late String? gender;
  late String? bloodGroup;
  late String role;

  Future<String?> _getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> _saveUserToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final token = await _getFcmToken();

    final userModel = UserModel(
      uid: user.uid,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      role: role,
      fcmToken: token,
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }

  void _verifyOtp() async {
    String otp =
        _otp1.text +
        _otp2.text +
        _otp3.text +
        _otp4.text +
        _otp5.text +
        _otp6.text;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await _saveUserToFirestore();

      // Navigate forward
    } catch (e) {
      debugPrint("OTP Verification Failed: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    verificationId = args["verificationId"];
    firstName = args["firstName"];
    lastName = args["lastName"];
    phone = args["phone"];
    dob = args["dob"];
    gender = args["gender"];
    bloodGroup = args["bloodGroup"];
    role = "user";
  }

  @override
  void dispose() {
    _otp1.dispose();
    _otp2.dispose();
    _otp3.dispose();
    _otp4.dispose();
    _otp5.dispose();
    _otp6.dispose();
    _focus1.dispose();
    _focus2.dispose();
    _focus3.dispose();
    _focus4.dispose();
    _focus5.dispose();
    _focus6.dispose();
    super.dispose();
  }

  Widget buildOtpBox(
    TextEditingController controller,
    FocusNode current,
    FocusNode? next,
  ) {
    return SizedBox(
      width: 48,
      height: 55,
      child: TextField(
        controller: controller,
        focusNode: current,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF4C4A99), width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && next != null) {
            next.requestFocus();
          } else if (value.isEmpty) {
            current.previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C4A99),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter the 6-digit code sent to',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOtpBox(_otp1, _focus1, _focus2),
                        buildOtpBox(_otp2, _focus2, _focus3),
                        buildOtpBox(_otp3, _focus3, _focus4),
                        buildOtpBox(_otp4, _focus4, _focus5),
                        buildOtpBox(_otp5, _focus5, _focus6),
                        buildOtpBox(_otp6, _focus6, null),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Resend code in 00:30',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF4C4A99),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _verifyOtp();
                        },
                        child: const Text(
                          'Verify & Proceed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: const [
                  Icon(Icons.language, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'English',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
