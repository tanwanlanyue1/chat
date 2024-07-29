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
}


extension NumberX on num{

  ///转字符串并修剪掉小数点后面的0
  ///- 19.0 --> 19
  ///- 20.02 -> 20.02
  ///- 23.1430 -> 23.143
  ///- fractionDigits 最多保留几位小数
  String toStringAsTrimZero({int fractionDigits = 2}){
    var pattern = '#';
    if(fractionDigits > 0){
      pattern += '.${List.filled(fractionDigits, '#').join()}';
    }
    return NumberFormat(pattern).format(this);
  }

  ///转金银币字符串，最多保留2位小数
  String toCoinString(){
    return toStringAsTrimZero(fractionDigits: 2);
  }

  ///将元转为分（人民币）
  int toRMBCents() => (this * 100).ceil();
}
