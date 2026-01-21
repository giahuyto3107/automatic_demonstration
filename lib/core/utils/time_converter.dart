class TimeConverter {
  TimeConverter._();

  static String secondToMinuteSecondString(int second) {
    int minute = second ~/ 60;
    int remainingSecond = second % 60;

    return "$minute:${remainingSecond.toString().padLeft(2, '0')}";
  }

  static String secondToMinuteString(int second) {
    int minute = second ~/ 60;
    return "$minute";
  }

  static String secondToSecondString(int second) {
    int remainingSecond = second % 60;
    return remainingSecond.toString().padLeft(2, '0');
  }
}