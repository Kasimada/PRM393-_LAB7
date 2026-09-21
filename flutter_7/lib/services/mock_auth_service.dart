import 'dart:async';

/// TẦNG DỊCH VỤ (SERVICE LAYER): MockAuthService
/// Chức năng: Đóng gói toàn bộ nghiệp vụ kiểm tra tài khoản và giả lập tương tác máy chủ (API Backend).
/// Lợi ích: Tách biệt hoàn toàn logic mạng/nghiệp vụ ra khỏi giao diện Widget, giúp code dễ bảo trì và dễ viết Unit Test.
class MockAuthService {
  /// Hàm: checkEmailAvailability
  /// - Chức năng: Kiểm tra xem email người dùng nhập đã tồn tại trong hệ thống hay chưa.
  /// - Dữ liệu đầu vào: [email] (chuỗi email đã được trim).
  /// - Dữ liệu trả về: [Future<bool>]
  ///     + true: Email khả dụng (chưa ai đăng ký).
  ///     + false: Email đã bị trùng (đã có người sử dụng).
  /// - Cơ chế hoạt động:
  ///     1. Sử dụng [Future.delayed] giả lập thời gian trễ của đường truyền mạng (2 giây).
  ///     2. Áp dụng quy tắc giả lập của đề bài: Nếu email bắt đầu bằng từ khóa "taken" (không phân biệt hoa thường)
  ///        thì coi như email này đã tồn tại trên server.
  Future<bool> checkEmailAvailability(String email) async {
    // Giả lập độ trễ mạng 2 giây
    await Future.delayed(const Duration(seconds: 2));

    final normalizedEmail = email.trim().toLowerCase();
    
    // Quy tắc kiểm tra: bắt đầu bằng "taken" -> email đã bị chiếm dụng
    if (normalizedEmail.startsWith('taken')) {
      return false; // Email đã tồn tại (không khả dụng)
    }

    return true; // Email hợp lệ và khả dụng
  }

  /// Hàm: registerAccount
  /// - Chức năng: Giả lập gửi thông tin đăng ký lên hệ thống sau khi đã kiểm tra email thành công.
  /// - Dữ liệu đầu vào: [name], [email], [password].
  /// - Dữ liệu trả về: [Future<bool>] (true nếu đăng ký thành công).
  Future<bool> registerAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    // Giả lập gửi gói tin đăng ký lên server mất 500ms
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
