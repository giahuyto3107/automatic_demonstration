import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_scanner.g.dart';

@riverpod
class QrScanner extends _$QrScanner {
  @override
  String? build() => null;

  void onCodeScanned(String code) {
    state = code;
    // You can add logic here to navigate or call an API based on the code
  }

  void reset() {
    state = null;
  }
}