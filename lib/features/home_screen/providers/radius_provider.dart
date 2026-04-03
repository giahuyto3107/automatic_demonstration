import 'package:riverpod_annotation/riverpod_annotation.dart';

// Phần này rất quan trọng để code generation hoạt động
part 'radius_provider.g.dart';

/// Provider to store the user-selected search radius for food stalls.
/// Resides in a separate provider to persist even when the food stall list
/// is in a loading state.
@riverpod
class Radius extends _$Radius {
  @override
  double build() {
    // Trả về giá trị khởi tạo (tương đương với (ref) => 500.0)
    return 500.0;
  }

  /// Phương thức để cập nhật radius (thay thế cho state.notifier.state = ...)
  void setRadius(double value) {
    state = value;
  }
}