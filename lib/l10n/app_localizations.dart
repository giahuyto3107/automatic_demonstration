import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appPrimaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá ẩm thực'**
  String get appPrimaryTitle;

  /// No description provided for @appSecondaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khu phố ẩm thực Vĩnh Khánh'**
  String get appSecondaryTitle;

  /// No description provided for @foodStallSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quán ăn gần bạn'**
  String get foodStallSectionTitle;

  /// No description provided for @gpsIsOff.
  ///
  /// In vi, this message translates to:
  /// **'GPS Tắt'**
  String get gpsIsOff;

  /// No description provided for @gpsIsOn.
  ///
  /// In vi, this message translates to:
  /// **'GPS Bật'**
  String get gpsIsOn;

  /// No description provided for @playAudio.
  ///
  /// In vi, this message translates to:
  /// **'Phát'**
  String get playAudio;

  /// No description provided for @skipAudio.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skipAudio;

  /// No description provided for @routing.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ đường'**
  String get routing;

  /// No description provided for @restoreAudio.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tác'**
  String get restoreAudio;

  /// No description provided for @audioIsPlaying.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát thuyết minh'**
  String get audioIsPlaying;

  /// No description provided for @audioIsStopped.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng'**
  String get audioIsStopped;

  /// No description provided for @audioIsStoppedButton.
  ///
  /// In vi, this message translates to:
  /// **'Dừng'**
  String get audioIsStoppedButton;

  /// No description provided for @confirmButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmButton;

  /// No description provided for @userCurrentLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của bạn'**
  String get userCurrentLocation;

  /// No description provided for @location.
  ///
  /// In vi, this message translates to:
  /// **'địa điểm'**
  String get location;

  /// No description provided for @all.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all;

  /// No description provided for @listened.
  ///
  /// In vi, this message translates to:
  /// **'Đã nghe'**
  String get listened;

  /// No description provided for @filter.
  ///
  /// In vi, this message translates to:
  /// **'Lọc'**
  String get filter;

  /// No description provided for @radius.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính'**
  String get radius;

  /// No description provided for @minute.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get minute;

  /// No description provided for @min.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu'**
  String get min;

  /// No description provided for @max.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa'**
  String get max;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @routingError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải chỉ đường'**
  String get routingError;

  /// No description provided for @emptyStallList.
  ///
  /// In vi, this message translates to:
  /// **'Không có quán nào'**
  String get emptyStallList;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @appPreferences.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt ứng dụng'**
  String get appPreferences;

  /// No description provided for @notification.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notification;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @chinese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Trung'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Hàn'**
  String get korean;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
