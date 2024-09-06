import 'package:flutter/services.dart';
import 'package:guanjia/widgets/loading.dart';

///小数输入格式化
class DecimalTextInputFormatter extends TextInputFormatter {

  ///最大值
  final num? maxValue;

  ///大于最大值的错误信息
  final String? maxValueHint;

  ///小数位精度
  final int decimalDigits;

  DecimalTextInputFormatter({
    this.decimalDigits = 0,
    this.maxValue,
    this.maxValueHint,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.trim();
    final ignores = ['', '0'];
    if(decimalDigits > 0){
      ignores.add('0.');
      for(var i=1; i<=decimalDigits; i++){
        ignores.add('0.'.padRight(i + 2, '0'));
      }

      if(text == ignores.last){
        return oldValue;
      }
    }

    print('==>${ignores}  $text');

    if(ignores.contains(text)){
      return TextEditingValue(text: text);
    }

    //检查00开头
    if(text.startsWith('00')){
      return oldValue;
    }

    //检查精度
    if(decimalDigits > 0){
      final index = text.indexOf('.');
      if(index != -1){
        final place = text.substring(index + 1);
        if(place.length > decimalDigits){
          return oldValue;
        }
      }
    }

    final value = double.tryParse(text);
    if (value == null) {
      return oldValue;
    }


    if(maxValue != null && value > maxValue! && maxValueHint != null){
      Loading.showToast(maxValueHint ?? '');
      return oldValue;
    }

    return newValue;
  }
}
