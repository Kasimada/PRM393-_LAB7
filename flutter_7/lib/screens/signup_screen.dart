import 'package:flutter/material.dart';

import '../services/mock_auth_service.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/registration_dialog.dart';
import '../widgets/signup_submit_button.dart';
import '../widgets/terms_checkbox.dart';

/// MÀN HÌNH CHÍNH (SCREEN): SignupScreen
/// Chức năng: Đóng vai trò là Điều phối viên (Orchestrator).
/// - Quản lý trạng thái FormState và GlobalKey.
/// - Liên kết các luồng Focus bàn phím ảo giữa các ô.
/// - Nhận dữ liệu và kích hoạt kiểm tra qua tầng nghiệp vụ MockAuthService.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. Khóa toàn cục để truy cập đối tượng FormState của Form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Khởi tạo các đối tượng tầng Dịch vụ và Tiện ích
  final _authService = MockAuthService();
  final _validatorService = ValidatorService(); // <--- Đã thêm Instance của ValidatorService

  // 3. Quản lý văn bản người dùng nhập vào
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 4. Quản lý tiêu điểm bàn phím ảo (Focus Nodes)
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // 5. Biến trạng thái giao diện (UI State)
  bool _agreeToTerms = false;
  bool _termsError = false;
  bool _isCheckingEmail = false;
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi của ô mật khẩu để cập nhật thanh đo độ mạnh (Password Strength) real-time
    _passwordController.addListener(() {
      setState(() {
        _currentPassword = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
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
  // HÀM XỬ LÝ SUBMIT & KIỂM TRA TÀI KHOẢN (ASYNC EMAIL CHECK)
  // ==========================================================================
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _termsError = !_agreeToTerms;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || !_agreeToTerms) {
      return; 
    }

    _formKey.currentState?.save();

    setState(() {
      _isCheckingEmail = true;
    });

    final emailInput = _emailController.text.trim();
    final isAvailable = await _authService.checkEmailAvailability(emailInput);

    if (!mounted) return;

    setState(() {
      _isCheckingEmail = false;
    });

    if (!isAvailable) {
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
      showRegistrationSuccessDialog(
        context,
        name: _nameController.text.trim(),
        email: emailInput,
        onOk: _resetForm,
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _formKey = GlobalKey<FormState>();
      _agreeToTerms = false;
      _termsError = false;
      _currentPassword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
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

                  // TRƯỜNG 1: FULL NAME
                  CustomTextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    // <--- Gọi hàm validate qua instance
                    validator: _validatorService.validateName, 
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                  ),
                  const SizedBox(height: 16),

                  // TRƯỜNG 2: EMAIL
                  CustomTextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    labelText: 'Email Address *',
                    hintText: 'name@example.com (try "taken@..." to test error)',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    // <--- Gọi hàm validate qua instance
                    validator: _validatorService.validateEmail, 
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  const SizedBox(height: 16),

                  // TRƯỜNG 3: PASSWORD
                  CustomTextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    labelText: 'Password *',
                    hintText: 'Min 8 chars with at least 1 digit',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    // <--- Gọi hàm validate qua instance
                    validator: _validatorService.validatePassword, 
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                    },
                  ),

                  // THANH ĐO ĐỘ MẠNH MẬT KHẨU
                  PasswordStrengthIndicator(
                    password: _currentPassword,
                    // <--- Truyền đối tượng ValidatorService xuống cho widget con
                    validatorService: _validatorService, 
                  ),
                  const SizedBox(height: 12),

                  // TRƯỜNG 4: CONFIRM PASSWORD
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    labelText: 'Confirm Password *',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icons.lock_reset,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    // <--- Gọi hàm validate qua instance, dùng closure để truyền tham số thứ 2
                    validator: (value) => _validatorService.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    onFieldSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 12),

                  // CHECKBOX ĐIỀU KHOẢN DỊCH VỤ
                  TermsAndConditionsCheckbox(
                    value: _agreeToTerms,
                    hasError: _termsError,
                    onChanged: (val) {
                      setState(() {
                        _agreeToTerms = val ?? false;
                        if (_agreeToTerms) {
                          _termsError = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // NÚT BẤM ĐĂNG KÝ
                  SignupSubmitButton(
                    isLoading: _isCheckingEmail,
                    onPressed: _submitForm,
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