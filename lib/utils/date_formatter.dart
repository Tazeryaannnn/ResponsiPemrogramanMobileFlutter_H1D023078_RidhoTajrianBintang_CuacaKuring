import 'package:cuaca_kuring/utils/app_strings.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDayLabel(
    DateTime date, {
    bool isToday = false,
    AppLanguage language = AppLanguage.id,
  }) {
    final strings = AppStrings(language);
    if (isToday) return strings.todayLabel;
    return strings.dayNames[date.weekday - 1];
  }

  static String formatShortDate(
    DateTime date, {
    AppLanguage language = AppLanguage.id,
  }) {
    final month = AppStrings(language).monthNames[date.month - 1];
    return '${date.day} $month';
  }

  static String formatApiTime(
    String isoString, {
    AppLanguage language = AppLanguage.id,
  }) {
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return isoString;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final month = AppStrings(language).monthNames[dt.month - 1];
    return '${dt.day} $month, $hour:$minute';
  }
}
