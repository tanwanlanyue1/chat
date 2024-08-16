
import 'package:intl/intl.dart';

extension DoubleX on num{

  ///转字符串并修剪掉小数点后面的0,最多保留2位小数点
  String toStringAsTrimZero(){
    return NumberFormat('#.##').format(this);
  }

  ///百分比
  String toPercent(){
    return '${(this * 100).toStringAsTrimZero()}%';
  }
  
}
