// lib/feature/auth/presentation/register_screen.dart
//

import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/auth/data/auth_service.dart';
import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';
import 'package:rashtraveer/feature/auth/presentation/verify_otp_screen.dart';
import 'package:rashtraveer/feature/auth/data/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _languageOptions = ['English', 'Hindi', 'Marathi'];
  String _selectedLanguage = 'English';

  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _acceptTerms = false;
  bool _isLoading = false; // [+] NEW — prevents double-tap

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final phoneNo = '+91${_phoneNumberController.text.trim()}';

    // Snapshot args before any async gap
    final args = {
      'firstName': _firstName.text.trim(),
      'lastName': _lastName.text.trim(),
      'phone': phoneNo,
      'dob': _dobController.text.trim(),
      'gender': _selectedGender,
      'bloodGroup': _selectedBloodGroup,
      'language': _selectedLanguage,
      'isLogin': false,
    };

    final repo = UserRepository();

    final exists = await repo.phoneExists(phoneNo);

    if (exists) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account already exists. Please login.')),
      );

      setState(() => _isLoading = false);
      return;
    }

    await _authService.sendOtp(
      phoneNumber: phoneNo,

      onCodeSent: (verificationId) {
        // [+] mounted check before using context after async gap
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.pushNamed(
          context,
          VerifyOtpScreen.routeName,
          arguments: {...args, 'verificationId': verificationId},
        );
      },

      onError: (error) {
        // [+] was only debugPrint — user saw nothing
        // if (!mounted) return;
        // setState(() => _isLoading = false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        // );

        if (!mounted) return;
        setState(() => _isLoading = false);
        // ADD THIS — print the raw error
        debugPrint('OTP ERROR: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      },

      // [+] NEW — handle auto-verification (SMS auto-read on Android)
      //     Without this, auto-verify skips Firestore and loses user data
      onAutoVerified: (credential) async {
        if (!mounted) return;
        Navigator.pushNamed(
          context,
          VerifyOtpScreen.routeName,
          arguments: {
            ...args,
            'verificationId': '',
            'autoCredential': credential,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C4A99),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Sign up to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 32),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // [*] FIXED — _buildInput is now a method on this class
                          _buildInput(
                            controller: _firstName,
                            label: 'First Name',
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          _buildInput(
                            controller: _lastName,
                            label: 'Last Name',
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmall = constraints.maxWidth < 350;

                              final dobField = GestureDetector(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dobController.text =
                                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: _buildInput(
                                    controller: _dobController,
                                    label: 'Date of Birth',
                                    icon: Icons.calendar_today_outlined,
                                    // [+] DOB-specific validator
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your date of birth';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );

                              // [+] validator added to gender dropdown
                              final genderField =
                                  DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: InputDecoration(
                                      labelText: 'Gender',
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: ['Male', 'Female', 'Other']
                                        .map(
                                          (g) => DropdownMenuItem(
                                            value: g,
                                            child: Text(g),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) =>
                                        setState(() => _selectedGender = value),
                                    // [+] NEW validator
                                    validator: (value) => value == null
                                        ? 'Please select your gender'
                                        : null,
                                  );

                              if (isSmall) {
                                return Column(
                                  children: [
                                    dobField,
                                    const SizedBox(height: 16),
                                    genderField,
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  Expanded(child: dobField),
                                  const SizedBox(width: 12),
                                  Expanded(child: genderField),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          _buildInput(
                            controller: _phoneNumberController,
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            // [+] 10-digit phone validator
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.trim().length != 10) {
                                return 'Enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // [+] validator added to blood group dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedBloodGroup,
                            decoration: InputDecoration(
                              labelText: 'Blood Group',
                              prefixIcon: const Icon(Icons.bloodtype_outlined),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items:
                                [
                                      'A+',
                                      'A-',
                                      'B+',
                                      'B-',
                                      'O+',
                                      'O-',
                                      'AB+',
                                      'AB-',
                                    ]
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedBloodGroup = value),
                            // [+] NEW validator
                            validator: (value) => value == null
                                ? 'Please select your blood group'
                                : null,
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: SizedBox(
                              width: 300,
                              child: CheckboxListTile(
                                value: _acceptTerms,
                                activeColor: const Color(0xFF4C4A99),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (value) =>
                                    setState(() => _acceptTerms = value!),
                                title: GestureDetector(
                                  onTap: () => _showTermsModal(context),
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: Color(0xFF4C4A99),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: const Color(0xFF4C4A99),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Disabled if terms not accepted OR loading
                              onPressed: (!_acceptTerms || _isLoading)
                                  ? null
                                  : _sendOtp,
                              // [+] Shows spinner while waiting for OTP
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  LoginScreen.routeName,
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Color(0xFF4C4A99)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    icon: const Icon(Icons.language),
                    borderRadius: BorderRadius.circular(12),
                    items: _languageOptions.map((language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [*] FIXED — moved inside the class; was a free function at file scope
  //     Now it can access Theme.of(context) if needed later
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator, // [+] optional override validator
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      // Use override validator if provided, else default non-empty check
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
    );
  }

  void _showTermsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: const Text(
                        'This is where your Terms & Conditions go.\n\n'
                        '1. You agree to provide accurate information.\n'
                        '2. You agree not to misuse the app.\n'
                        '3. Your data will be handled securely.\n\n',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C4A99),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
