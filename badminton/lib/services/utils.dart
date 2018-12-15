class Utils {

  static bool isSameDay(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month &&
        first.day == second.day;
}