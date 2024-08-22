import 'package:common_utils/common_utils.dart';
import 'package:intl/intl.dart';

extension IntExtension on int {
  String get toPracticeValue {
    if (this < 10000) {
      return toString();
    } else if (this < 10000000) {
      return "${this / 1000.0}k";
    } else {
      return "${this / 1000000.0}M";
    }
  }

  DateTime get dateTime {
    return DateTime.fromMicrosecondsSinceEpoch(this);
  }
}
