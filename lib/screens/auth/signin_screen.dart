import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  int _activeTab = 0; // 0 for Log In, 1 for Sign Up
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill dummy credentials
    _emailController.text = 'test@gmail.com';
    _passwordController.text = 'Test123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient background - Full width
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF001a4d),
                    const Color(0xFF003d99),
                    const Color(0xFF0052cc),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QIPHLOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'It is a long established fact that a reader',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB0C4FF),
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            // Form section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Log In / Sign Up tabs
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTab = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _activeTab == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Log In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _activeTab == 0
                                      ? const Color(0xFF14103B)
                                      : const Color(0xFFCCCCCC),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTab = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _activeTab == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _activeTab == 1
                                      ? const Color(0xFF14103B)
                                      : const Color(0xFFCCCCCC),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tab content
                  if (_activeTab == 0) _buildLogInForm() else _buildSignUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Dummy credentials
    const String dummyEmail = 'test@gmail.com';
    const String dummyPassword = 'Test123';

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    if (email == dummyEmail && password == dummyPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
    }
  }

  Widget _buildLogInForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        const Text(
          'Username/Email',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(_emailController, 'Enter your email or username', false),
        const SizedBox(height: 16),
        // Password field
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(_passwordController, 'Enter your password', _obscurePassword, (value) {
          setState(() {
            _obscurePassword = value;
          });
        }),
        const SizedBox(height: 16),
        // Remember me and Forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _rememberMe
                            ? const Color(0xFF0052cc)
                            : const Color(0xFFCCCCCC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _rememberMe
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFF0052cc),
                            size: 14,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0052cc),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Log In button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _handleLogIn();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001a4d),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Log In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Or login with
        const Center(
          child: Text(
            'Or login with',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFCCCCCC),
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSocialButton(FontAwesomeIcons.google, 'Google'),
            _buildSocialButton(FontAwesomeIcons.facebook, 'Facebook'),
            _buildSocialButton(FontAwesomeIcons.apple, 'Apple'),
            _buildSocialButton(FontAwesomeIcons.phone, 'Phone'),
          ],
        ),
        const SizedBox(height: 24),
        // Terms and conditions
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(text: 'By logging in, you agree to the\n'),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Color(0xFF14103B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFF14103B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full name
        const Text(
          'Full name',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(_fullNameController, 'Enter your full name', false),
        const SizedBox(height: 16),
        // Username
        const Text(
          'Username',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(_usernameController, 'Choose a username', false),
        const SizedBox(height: 16),
        // Email
        const Text(
          'Username/Email',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(_emailController, 'Enter your email', false),
        const SizedBox(height: 16),
        // Password
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(_passwordController, 'Create a password', _obscurePassword, (value) {
          setState(() {
            _obscurePassword = value;
          });
        }),
        const SizedBox(height: 16),
        // Confirm password
        const Text(
          'Confirm password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(_confirmPasswordController, 'Confirm your password', _obscureConfirmPassword, (value) {
          setState(() {
            _obscureConfirmPassword = value;
          });
        }),
        const SizedBox(height: 16),
        // Phone
        const Text(
          'Phone',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFEEEEEE),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFAFAFA),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: const Color(0xFFEEEEEE),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: const [
                    Text(
                      '🇬🇧',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+44',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Color(0xFFCCCCCC), size: 20),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF14103B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Sign Up button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001a4d),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Terms and conditions
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(text: 'By logging in, you agree to the\n'),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Color(0xFF14103B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFF14103B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF0052cc),
            width: 1,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF14103B),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool obscure,
    Function(bool) onToggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF0052cc),
            width: 1,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            onToggle(!obscure);
          },
          child: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF0052cc),
            size: 20,
          ),
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF14103B),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      child: Icon(icon, color: const Color(0xFF0052cc), size: 24),
    );
  }
}
