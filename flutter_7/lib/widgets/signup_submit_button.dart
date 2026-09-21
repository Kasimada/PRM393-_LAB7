import 'package:flutter/material.dart';

/// WIDGET TÁI SỬ DỤNG: SignupSubmitButton
/// Chức năng: Nút bấm Đăng ký tài khoản, tự động xử lý trạng thái Loading xoay vòng
/// khi ứng dụng đang gọi async check email trên server giả lập.
class SignupSubmitButton extends StatelessWidget {
  /// Cờ trạng thái đang tải (true khi đang gửi request mạng)
  final bool isLoading;

  /// Callback thực thi hành động submit (nếu isLoading = true thì nút sẽ tự động bị vô hiệu hóa)
  final VoidCallback? onPressed;

  const SignupSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        // Khi đang loading, truyền null vào onPressed để tự động vô hiệu hóa nút (Disable)
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.teal.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        // Hoán đổi nội dung nút bấm dựa theo biến isLoading
        child: isLoading
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'Sign Up',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
