import 'package:flutter/material.dart';

/// HÀM TIỆN ÍCH HIỂN THỊ HỘP THOẠI: showRegistrationSuccessDialog
/// Chức năng: Hiển thị hộp thoại AlertDialog thông báo đăng ký thành công, liệt kê thông tin người dùng đã tạo.
void showRegistrationSuccessDialog(
  BuildContext context, {
  required String name,
  required String email,
  required VoidCallback onOk,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Bắt buộc bấm OK mới đóng hộp thoại
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
          Text(
            'Full Name: $name',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            'Email: $email',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
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
            Navigator.pop(dialogContext); // Đóng dialog
            onOk(); // Thực thi callback (ví dụ: reset form)
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
