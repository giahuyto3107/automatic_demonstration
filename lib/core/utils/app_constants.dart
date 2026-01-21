/// Các hằng số về kích thước, padding, margin, và các giá trị số khác
/// Sử dụng để đảm bảo tính nhất quán về spacing và sizing trong toàn bộ app
class AppConstants {
  AppConstants._(); // Private constructor để ngăn khởi tạo

  // ============ Spacing/Padding ============

  /// Spacing cực cực nhỏ: 2.0
  static const double spacingXXS = 2.0;

  /// Spacing cực nhỏ: 4.0
  static const double spacingXS = 4.0;

  /// Spacing nhỏ: 8.0
  static const double spacingS = 8.0;

  /// Spacing vừa: 12.0
  static const double spacingM = 12.0;

  /// Spacing lớn: 16.0
  static const double spacingL = 16.0;

  /// Spacing rất lớn: 24.0
  static const double spacingXL = 24.0;

  /// Spacing cực lớn: 32.0
  static const double spacingXXL = 32.0;

  /// Spacing khổng lồ: 48.0
  static const double spacingXXXL = 48.0;


  // Spacing bottom navigation bar
  static const double spacingNavigationBar = 100.0;
  // static const double spacingNavigationBar = 0.0;

  // ============ Border Radius ============

  /// Border radius nhỏ: 4.0
  static const double radiusS = 4.0;

  /// Border radius vừa: 8.0
  static const double radiusM = 8.0;

  /// Border radius lớn: 12.0
  static const double radiusL = 12.0;

  /// Border radius rất lớn: 16.0
  static const double radiusXL = 16.0;

  /// Border radius cực lớn: 24.0
  static const double radiusXXL = 24.0;

  /// Border radius tròn hoàn toàn
  static const double radiusCircular = 999.0;

  // ============ Icon Sizes ============

  /// Icon size cực nhỏ: 16.0
  static const double iconXS = 16.0;

  /// Icon size nhỏ: 20.0
  static const double iconS = 20.0;

  /// Icon size vừa: 24.0
  static const double iconM = 24.0;

  /// Icon size lớn: 32.0
  static const double iconL = 32.0;

  /// Icon size rất lớn: 48.0
  static const double iconXL = 48.0;

  /// Icon size cực lớn: 64.0
  static const double iconXXL = 64.0;

  // ============ Font Sizes ============

  /// Font size cực nhỏ: 10.0
  static const double fontXS = 10.0;

  /// Font size nhỏ: 12.0
  static const double fontS = 12.0;

  /// Font size vừa: 14.0
  static const double fontM = 14.0;

  /// Font size lớn: 16.0
  static const double fontL = 16.0;

  /// Font size rất lớn: 18.0
  static const double fontXL = 18.0;

  /// Font size cực lớn: 20.0
  static const double fontXXL = 20.0;

  /// Font size cực lớn: 20.0
  static const double fontXXXL = 22.0;

  /// Font size cho tiêu đề nhỏ: 24.0
  static const double fontTitleS = 24.0;

  /// Font size cho tiêu đề vừa: 28.0
  static const double fontTitleM = 28.0;

  /// Font size cho tiêu đề lớn: 32.0
  static const double fontTitleL = 32.0;

  // ============ Font Weights ============

  // light = "w300";
  // regular = "w400";
  // medium = "w500";
  // semiBold = "w600";
  // bold = "w700";

  // ============ Elevation/Shadow ============

  /// Elevation nhỏ
  static const double elevationS = 2.0;

  /// Elevation vừa
  static const double elevationM = 4.0;

  /// Elevation lớn
  static const double elevationL = 8.0;

  /// Elevation rất lớn
  static const double elevationXL = 16.0;

  // ============ Border Width ============

  /// Border width mỏng
  static const double borderThin = 1.0;

  /// Border width vừa
  static const double borderMedium = 2.0;

  /// Border width dày
  static const double borderThick = 3.0;

  // ============ Button Sizes ============

  /// Chiều cao button nhỏ
  static const double buttonHeightS = 36.0;

  /// Chiều cao button vừa
  static const double buttonHeightM = 48.0;

  /// Chiều cao button lớn
  static const double buttonHeightL = 56.0;

  /// Padding ngang button
  static const double buttonPaddingH = 24.0;

  // ============ Card/Container Sizes ============

  /// Chiều cao card nhỏ
  static const double cardHeightS = 80.0;

  /// Chiều cao card vừa
  static const double cardHeightM = 120.0;

  /// Chiều cao card lớn
  static const double cardHeightL = 180.0;

  /// Padding trong card
  static const double cardPadding = 16.0;

  // ============ AppBar ============

  /// Chiều cao AppBar
  static const double appBarHeight = 56.0;

  /// Chiều cao AppBar lớn
  static const double appBarHeightLarge = 128.0;

  // ============ Bottom Navigation Bar ============

  /// Chiều cao BottomNavigationBar
  static const double bottomNavHeight = 60.0;

  // ============ Animation Durations (milliseconds) ============

  /// Animation ngắn: 200ms
  static const int animationShort = 200;

  /// Animation vừa: 300ms
  static const int animationMedium = 300;

  /// Animation dài: 500ms
  static const int animationLong = 500;


  // ============ Database ============

  /// Tên database
  static const String databaseName = 'nutripal.db';

  /// Phiên bản database
  static const int databaseVersion = 1;

  // ============ Resend ============

  static const int resendTimeCountdown = 15;

  // ============ Assets Paths ============

  // static const String assetHomeBackground = 'assets/home_background.png';
  // static const String assetIllustrativeImage = 'assets/illustrative_image.png';
  // static const String assetNotificationImage = 'assets/notification_image.svg';
  // static const String assetPanther = 'assets/panther.svg';
  // static const String assetRabbit = 'assets/rabbit.svg';
  // static const String assetTurtle = 'assets/turtle.svg';

  // ============ Local Storage Keys ============

  // static const String keyUserProfile = 'user_profile';
  // static const String keyUserSettings = 'user_settings';
  // static const String keyThemeMode = 'theme_mode';
  // static const String keyLanguage = 'language';
  // static const String keyUnits = 'units';
  // static const String keyOnboardingComplete = 'onboarding_complete';
  // static const String keyNotificationsEnabled = 'notifications_enabled';

  // ============ Date/Time Formats ============

  static const String dateFormatFull = 'dd/MM/yyyy';
  static const String dateFormatShort = 'dd/MM';
  static const String timeFormat24 = 'HH:mm';
  static const String timeFormat12 = 'hh:mm a';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // ============ Regular Expressions ============

  /// Pattern cho email
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// Pattern cho số điện thoại Việt Nam
  static const String phonePattern = r'^(0|\+84)(\d{9,10})$';

  // ============ Network ============

  /// Timeout cho request (seconds)
  static const int requestTimeout = 30;

  /// Số lần retry tối đa
  static const int maxRetries = 3;

  // ============ Pagination ============

  /// Số item mỗi trang
  static const int itemsPerPage = 20;

  /// Số item tải thêm
  static const int loadMoreThreshold = 5;


  // ============ showDatePicker ============

  /// firstDay cua DatePicker
  static const int firstDateDatePicker = 1900;

  /// lastDay cua DatePicker
  static int lastDateDatePicker = DateTime.now().year + 1;

  /// Short time span
  static DateTime shortTimeSpanStart = DateTime.now().add(const Duration(days: -55));
  static DateTime shortTimeSpanEnd = DateTime.now();

  // ============ background ============

  static String backgroundImagePath = "assets/home_background.png";

  static get fontBodyM => null;

}

