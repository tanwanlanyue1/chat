
import 'package:intl/intl.dart';

extension NumberX on num{

  ///转字符串并修剪掉小数点后面的0,最多保留2位小数点
  String toStringAsTrimZero(){
    return NumberFormat('#.##').format(this);
  }

  ///百分比
  String toPercent({double scale = 100}){
    return '${(this * scale).toStringAsTrimZero()}%';
  }

  ///转金银币字符串，最多保留2位小数
  String toCoinString(){
    return toStringAsTrimZero();
  }

  ///转换为货币显示
  ///- unit 货币单位
  String toCurrencyString({String unit = '\$'}){
    return toStringAsTrimZero()+unit;
  }
  
}
