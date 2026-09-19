import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../widgets/password_strength_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey to manage FormState and perform validation
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers to retrieve user inputs
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // FocusNodes to manage keyboard navigation between fields
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // State variables for toggling password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Bonus: Terms and conditions agreement state
  bool _agreeToTerms = false;
  bool _termsError = false;

  // Async Email check state
  bool _isCheckingEmail = false;

  // Current password value for dynamic password strength calculation
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    // Listen to password changes to update strength indicator dynamically
    _passwordController.addListener(() {
      setState(() {
        _currentPassword = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // ==========================================================================
  // SUBMIT FORM & ASYNC EMAIL CHECK (Lab 7.1, 7.2, 7.4)
  // ==========================================================================
  Future<void> _submitForm() async {
    // Dismiss the virtual keyboard
    FocusScope.of(context).unfocus();

    // Check Terms & Conditions checkbox
    if (!_agreeToTerms) {
      setState(() {
        _termsError = true;
      });
    } else {
      setState(() {
        _termsError = false;
      });
    }

    // Validate form fields
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || !_agreeToTerms) {
      return;
    }

    // Save form state (if Form.onSaved callbacks are used)
    _formKey.currentState?.save();

    // Lab 7.4: Perform simulated async email check
    setState(() {
      _isCheckingEmail = true;
    });

    // Simulate network delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final emailInput = _emailController.text.trim().toLowerCase();
    // Fake server check: emails starting with "taken" are treated as unavailable
    final isEmailTaken = emailInput.startsWith('taken');

    setState(() {
      _isCheckingEmail = false;
    });

    if (isEmailTaken) {
      // Show error notification when email is already in use
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('This email ($emailInput) is already taken. Please use another email.'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      // Registration successful -> Show confirmation dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Registration Successful'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name: ${_nameController.text.trim()}'),
              const SizedBox(height: 6),
              Text('Email: ${_emailController.text.trim()}'),
              const SizedBox(height: 12),
              Text(
                'Your account has been created successfully with strong security verification.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _agreeToTerms = false;
      _termsError = false;
      _currentPassword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lab 7.3: GestureDetector to dismiss keyboard on tapping outside
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: SafeArea(
          // Lab 7.3: SingleChildScrollView avoids bottom overflow when keyboard opens
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              // Lab 7.2: AutovalidateMode.onUserInteraction gives immediate feedback
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFE0F2F1),
                      child: Icon(Icons.person_add_alt_1, size: 40, color: Colors.teal),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Create an Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fill in the form below to complete your registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // 1. FULL NAME FIELD
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: Validators.validateName,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. EMAIL FIELD
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email Address *',
                      hintText: 'name@example.com (try "taken@..." to test error)',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: Validators.validateEmail,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. PASSWORD FIELD
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      hintText: 'Min 8 chars with at least 1 digit',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: Validators.validatePassword,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                    },
                  ),

                  // Bonus: Password Strength Indicator
                  PasswordStrengthIndicator(password: _currentPassword),
                  const SizedBox(height: 12),

                  // 4. CONFIRM PASSWORD FIELD
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password *',
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    onFieldSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 12),

                  // Bonus: Terms & Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                            if (_agreeToTerms) {
                              _termsError = false;
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                              if (_agreeToTerms) {
                                _termsError = false;
                              }
                            });
                          },
                          child: const Text(
                            'I agree to the Terms & Conditions and Privacy Policy',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_termsError)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      child: Text(
                        'You must accept the terms & conditions to register',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // SUBMIT BUTTON (Lab 7.1 + Lab 7.4)
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isCheckingEmail ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.teal.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isCheckingEmail
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Checking email availability...',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
