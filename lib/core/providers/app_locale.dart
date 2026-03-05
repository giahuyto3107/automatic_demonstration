import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() => const Locale('vi');

  void setLocale(String languageCode) {
    state = Locale(languageCode);
  }
}