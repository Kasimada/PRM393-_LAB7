import 'package:flutter/material.dart';

/// WIDGET TÁI SỬ DỤNG: CustomTextFormField
/// Chức năng: Đóng gói toàn bộ cấu hình hiển thị, icon, kiểu nhập liệu và nút ẩn/hiện mật khẩu của một ô nhập liệu.
/// Giúp loại bỏ hoàn toàn việc lặp lại mã nguồn cấu hình TextFormField trong màn hình chính.
class CustomTextFormField extends StatefulWidget {
  /// Bộ điều khiển để đọc và thay đổi nội dung văn bản
  final TextEditingController controller;

  /// Nút quản lý tiêu điểm con trỏ và bàn phím ảo
  final FocusNode? focusNode;

  /// Nhãn hiển thị phía trên ô nhập (VD: 'Full Name *', 'Password *')
  final String labelText;

  /// Dòng chữ gợi ý mờ hiển thị bên trong ô khi chưa nhập liệu
  final String? hintText;

  /// Icon đại diện hiển thị ở đầu ô nhập
  final IconData prefixIcon;

  /// Cờ xác định xem đây có phải là trường mật khẩu hay không (mặc định false).
  /// Nếu là true, widget sẽ tự động bật tính năng ẩn chữ và thêm nút icon con mắt để bật/tắt.
  final bool isPassword;

  /// Kiểu bàn phím hiển thị trên điện thoại (email, số, văn bản thường)
  final TextInputType keyboardType;

  /// Nút hành động ở góc dưới bàn phím ảo (Next hoặc Done)
  final TextInputAction textInputAction;

  /// Hàm kiểm tra tính hợp lệ: Nhận giá trị chuỗi nhập vào, trả về null nếu đúng hoặc chuỗi lỗi màu đỏ nếu sai.
  /// Được gọi tự động bởi FormState.validate() hoặc khi người dùng gõ phím (AutovalidateMode).
  final String? Function(String?)? validator;

  /// Callback kích hoạt khi người dùng ấn nút Next hoặc Done trên bàn phím ảo
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // Biến trạng thái ẩn/hiện nội dung mật khẩu
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Nếu là ô mật khẩu thì mặc định ban đầu sẽ ẩn đi (_obscureText = true)
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon),
        // Nếu là mật khẩu -> Hiển thị nút IconButton con mắt ở đuôi ô nhập
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Đảo ngược trạng thái ẩn/hiện
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
