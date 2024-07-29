import 'package:common_utils/common_utils.dart';

///日期扩展
extension DateTimeExtension on DateTime {

  ///日期格式化 HH:mm
  String get formatHHmm => DateUtil.formatDate(this, format: 'HH:mm');

  ///日期格式化 HH:mm:ss
  String get formatHHmmss => DateUtil.formatDate(this, format: 'HH:mm:ss');

  ///日期格式化 yyyy-MM
  String get formatYM => DateUtil.formatDate(this, format: 'yyyy-MM');

  ///日期格式化 yyyy-MM-dd
  String get formatYMD => DateUtil.formatDate(this, format: 'yyyy-MM-dd');

  ///日期格式化 yyyy-MM-dd HH:mm:ss
  String get format => DateUtil.formatDate(this, format: 'yyyy-MM-dd HH:mm:ss');

  ///是否是今天
  bool get isToday => isSameDay(today);

  ///今天
  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  ///是否是同一天
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
