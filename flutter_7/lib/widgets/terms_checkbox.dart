import 'package:flutter/material.dart';

/// WIDGET TÁI SỬ DỤNG: TermsAndConditionsCheckbox
/// Chức năng: Hiển thị Checkbox đồng ý với Điều khoản dịch vụ và hiển thị dòng chữ cảnh báo lỗi đỏ bên dưới nếu chưa tick.
class TermsAndConditionsCheckbox extends StatelessWidget {
  /// Trạng thái đã tick chọn hay chưa (true/false)
  final bool value;

  /// Callback kích hoạt khi người dùng thay đổi trạng thái tick
  final ValueChanged<bool?> onChanged;

  /// Cờ báo lỗi: true nếu người dùng bấm submit mà chưa tick checkbox
  final bool hasError;

  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              activeColor: Colors.teal,
              onChanged: onChanged,
            ),
            Expanded(
              // Cho phép chạm vào cả đoạn text để đảo trạng thái tick của checkbox
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: const Text(
                  'I agree to the Terms & Conditions and Privacy Policy',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
        // Dòng chữ báo lỗi màu đỏ xuất hiện khi hasError = true
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
            child: Text(
              'You must accept the terms & conditions to register',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
