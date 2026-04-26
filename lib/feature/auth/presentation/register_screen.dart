import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';
// import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen1.dart';
import 'package:rashtraveer/feature/auth/data/auth_service.dart';
import 'package:rashtraveer/feature/auth/presentation/verify_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  // final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  // final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedBloodGroup;
  // final bool _obscurePassword = true;
  // final bool _isLoading = false;
  bool _acceptTerms = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    // _emailController.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phoneNo = "+91${_phoneNumberController.text.trim()}";

    await _authService.sendOtp(
      phoneNumber: phoneNo,

      onCodeSent: (verificationId) {
        Navigator.pushNamed(
          context,
          VerifyOtpScreen.routeName,
          arguments: {
            "verificationId": verificationId,
            "firstName": _firstName.text,
            "lastName": _lastName.text,
            "phone": phoneNo,
            "dob": _dobController.text,
            "gender": _selectedGender,
            "bloodGroup": _selectedBloodGroup,
          },
        );
      },

      onError: (error) {
        debugPrint(error);
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
            /// 🔹 MAIN SCROLLABLE CONTENT
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60), // space for top row

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
                          _buildInput(
                            controller: _firstName,
                            label: "First Name",
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          _buildInput(
                            controller: _lastName,
                            label: "Last Name",
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmall = constraints.maxWidth < 350;

                              final dobField = GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _dobController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: _buildInput(
                                    controller: _dobController,
                                    label: "DOB",
                                    icon: Icons.calendar_today_outlined,
                                  ),
                                ),
                              );

                              final genderField =
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedGender,
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
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
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

                          // _buildInput(
                          //   controller: _emailController,
                          //   label: "Email",
                          //   icon: Icons.email_outlined,
                          // ),
                          const SizedBox(height: 16),

                          _buildInput(
                            controller: _phoneNumberController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                          ),

                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            initialValue: _selectedBloodGroup,
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
                            onChanged: (value) {
                              setState(() {
                                _selectedBloodGroup = value;
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          // _buildInput(
                          //   controller: _passwordController,
                          //   label: "Password",
                          //   icon: Icons.lock_outline,
                          //   obscure: true,
                          // ),
                          const SizedBox(height: 8),

                          Center(
                            child: SizedBox(
                              width: 300,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: const CheckboxThemeData(
                                    shape: RoundedRectangleBorder(),
                                  ),
                                ),
                                child: CheckboxListTile(
                                  value: _acceptTerms,
                                  activeColor: const Color(0xFF4C4A99),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value!;
                                    });
                                  },
                                  title: GestureDetector(
                                    onTap: () {
                                      _showTermsModal(context);
                                    },
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(text: "I agree to the "),
                                          TextSpan(
                                            text: "Terms & Conditions",
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
                              onPressed: (!_acceptTerms)
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _sendOtp();
                                      }
                                    },
                              child: const Text(
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
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routeName,
                                  );
                                },
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

            /// 🔹 TOP RIGHT LANGUAGE
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: const [
                  Icon(Icons.language, color: Colors.grey),
                  SizedBox(width: 6),
                  Text('English', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
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
                    "Terms & Conditions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: const Text(
                        "This is where your Terms & Conditions go.\n\n"
                        "1. You agree to provide accurate information.\n"
                        "2. You agree not to misuse the app.\n"
                        "3. Your data will be handled securely.\n\n",
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Close",
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

Widget _buildInput({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscure = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
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
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $label';
      }
      return null;
    },
  );
}
