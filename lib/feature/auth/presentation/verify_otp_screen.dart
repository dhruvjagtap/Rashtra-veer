// lib/feature/auth/presentation/verify_otp_screen.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/auth/data/auth_service.dart';
import 'package:rashtraveer/feature/auth/model/user_model.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rashtraveer/providers/repository_provider.dart';
import 'package:rashtraveer/feature/auth/presentation/register_screen.dart';
import 'package:rashtraveer/providers/user_provider.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  static const routeName = '/verify-otp';
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String _verificationId = '';
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _dob = '';
  String _language = 'English';
  String? _gender;
  String? _bloodGroup;
  bool _isLogin = false;
  PhoneAuthCredential? _autoCredential;

  bool _isVerifying = false;
  bool _isResending = false;

  Timer? _timer;
  int _secondsLeft = 30;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractArgs();
      if (_autoCredential != null) {
        _verifyWithCredential(_autoCredential!);
      }
    });
  }

  Future<UserModel?> _loadUser(String uid) async {
    final repo = ref.read(userRepositoryProvider);

    return await repo.getUser(uid);
  }

  void _extractArgs() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) return;

    setState(() {
      _verificationId = args['verificationId'] as String? ?? '';
      _firstName = args['firstName'] as String? ?? '';
      _lastName = args['lastName'] as String? ?? '';
      _phone = args['phone'] as String? ?? '';
      _dob = args['dob'] as String? ?? '';
      _gender = args['gender'] as String?;
      _bloodGroup = args['bloodGroup'] as String?;
      _language = args['language'] as String? ?? 'English';
      _isLogin = args['isLogin'] as bool? ?? false;
      _autoCredential = args['autoCredential'] as PhoneAuthCredential?;
    });
  }

  void _startCountdown() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _clearOtpBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  Future<String?> _getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  Future<void> _createUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;

    final token = await _getFcmToken();

    final user = UserModel(
      uid: firebaseUser.uid,
      firstName: _firstName,
      lastName: _lastName,
      phone: _phone,
      dob: _dob,
      gender: _gender,
      bloodGroup: _bloodGroup,
      role: 'user',
      fcmToken: token,
      language: _language,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(userRepositoryProvider);

    await repo.createUser(user);

    ref.read(userProvider.notifier).setUser(user);
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;

    UserModel? user = ref.read(userProvider);

    user ??= await _loadUser(firebaseUser.uid);

    if (user != null) {
      ref.read(userProvider.notifier).setUser(user);
    }

    // Login but user doc missing
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RegisterScreen.routeName,
        (_) => false,
      );
      return;
    }

    if (!(user.onboardingCompleted ?? false)) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        OnBoardingScreen1.routeName,
        (_) => false,
      );
      return;
    }

    if (!(user.paymentCompleted ?? false)) {
      Navigator.pushNamedAndRemoveUntil(context, '/payment', (_) => false);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  Future<void> _verifyWithCredential(PhoneAuthCredential credential) async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!_isLogin) {
        await _createUser();
      }

      await _navigateToNextScreen();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => _isVerifying = false);

      _clearOtpBoxes();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'OTP verification failed. Try again.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isVerifying = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otp,
    );

    await _verifyWithCredential(credential);
  }

  Future<void> _resendOtp() async {
    if (_isResending) return;
    setState(() => _isResending = true);

    await _authService.resendOtp(
      phoneNumber: _phone,
      onCodeSent: (newVerificationId) {
        if (!mounted) return;
        setState(() {
          _verificationId = newVerificationId;
          _isResending = false;
        });
        _clearOtpBoxes();
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent again!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _isResending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      },
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      height: 55,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
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
          if (value.length == 1) {
            if (index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              _focusNodes[index].unfocus();
              _verifyOtp();
            }
          } else if (value.isEmpty) {
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format seconds as MM:SS
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

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
                      _phone.isEmpty ? '...' : _phone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, _buildOtpBox),
                    ),

                    const SizedBox(height: 24),

                    if (_secondsLeft > 0)
                      Text(
                        'Resend code in $minutes:$seconds',
                        style: const TextStyle(color: Colors.grey),
                      )
                    else
                      _isResending
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF4C4A99),
                              ),
                            )
                          : TextButton(
                              onPressed: _resendOtp,
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Color(0xFF4C4A99),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                        onPressed: _isVerifying ? null : _verifyOtp,
                        child: _isVerifying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
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
