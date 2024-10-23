import 'package:guanjia/common/service/service.dart';
import 'package:intl/intl.dart';

extension NumberX on num {
  ///转字符串并修剪掉小数点后面的0,默认最多保留2位小数点
  String toStringAsTrimZero({int fractionDigits = 2}) {
    var pattern = '#';
    if(fractionDigits > 0){
      pattern += '.${List.filled(fractionDigits, '#').join()}';
    }
    return NumberFormat(pattern).format(this);
  }

  ///百分比
  String toPercent({double scale = 100}) {
    return '${(this * scale).toStringAsTrimZero()}%';
  }

  ///转金银币字符串，最多保留2位小数
  String toCoinString() {
    return toStringAsTrimZero();
  }

  ///转换为货币显示
  ///- unit 货币单位
  ///- beforeUnit 货币单位前置
  String toCurrencyString({String? unit, bool afterUnit = false}) {
    final currencyUnit = unit ?? SS.appConfig.currencyUnit;
    if (afterUnit) {
      return toStringAsTrimZero() + currencyUnit;
    } else {
      return currencyUnit + toStringAsTrimZero();
    }
  }

  ///格式化为距离显示，最多保留1为小数点
  String toDistance() {
    if (this < 1000) {
      return '${round()}m';
    }else{
      return '${(this/1000).toStringAsTrimZero(fractionDigits: 1)}km';
    }
  }
}
