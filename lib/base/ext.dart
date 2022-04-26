extension DateCheck on DateTime {
  // check if given dateTime is Less than 5 minutes from now
  bool isJustNow() {
    final DateTime now = DateTime.now();
    if (now.millisecondsSinceEpoch - millisecondsSinceEpoch <= 5 * 60 * 1000) {
      return true;
    }

    return false;
  }

  // check if given dateTime is Today
  bool isToday() {
    final DateTime now = DateTime.now();
    return day == now.day;
  }

  // check if given dateTime is Yesterday
  bool isYesterday() {
    final DateTime now = DateTime.now();
    final int between = now.millisecondsSinceEpoch - millisecondsSinceEpoch;
    return between > 24 * 60 * 60 * 1000 && between <= 48 * 60 * 60 * 1000;
  }
}