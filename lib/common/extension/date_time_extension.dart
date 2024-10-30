import 'package:common_utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';

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

  ///日期格式化 yyyy/MM/dd
  String get formatYMD2 => DateUtil.formatDate(this, format: 'yyyy/MM/dd');

  ///日期格式化 yyyy-MM-dd HH:mm:ss
  String get format => DateUtil.formatDate(this, format: 'yyyy-MM-dd HH:mm:ss');

  ///日期格式化 yyyy/MM/dd HH:mm:ss
  String get format2 => toFormat('yyyy/MM/dd HH:mm:ss');

  ///日期格式化 yyyy/MM/dd HH:mm
  String get formatYMDHHmm2 => toFormat('yyyy/MM/dd HH:mm');

  String toFormat(String format){
    return DateUtil.formatDate(this, format: format);
  }

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

  ///获取本月的最后一天的时间
  DateTime get lastDayOfMonth{
    if(month < 12){
      return copyWith(month: month + 1, day: 0);
    }else{
      return copyWith(year: year + 1, month: 1, day: 0);
    }
  }

  ///友好显示时间
  String get friendlyTime {
    final now = DateTime.now();
    final duration = now.difference(this);
    var timeStr = '';
    if (duration.inMinutes < 1) {
      timeStr = S.current.justNow;
    } else if (duration.inHours < 1) {
      timeStr = S.current.aMinuteAgo(duration.inMinutes);
    } else if (duration.inDays < 1) {
      timeStr = S.current.aHoursAgo(duration.inHours);
    } else if (now.year == year) {
      timeStr = S.current.mdFormat(month, day);
    } else {
      timeStr = S.current.ymdFormat(year, month, day);
    }
    return timeStr;
  }
}

extension DurationExtension on Duration{
  ///格式化 HH:mm:ss
  String get formatHHmmss{
    final hh = inHours.toString().padLeft(2, '0');
    final mm = (inMinutes % 60).toString().padLeft(2, '0');
    final ss = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}
