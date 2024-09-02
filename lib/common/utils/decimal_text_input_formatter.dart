import 'package:flutter/services.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

///小数输入格式化
class DecimalTextInputFormatter extends NumberTextInputFormatter {

  ///最大值
  final num? _maxValue;
  num? get maxValue => _maxValue;

  ///大于最大值的错误信息
  final String? maxValueHint;

  DecimalTextInputFormatter({
    super.decimalDigits,
    num? maxValue,
    this.maxValueHint,
  })  : _maxValue = maxValue, super(fixNumber: false, maxValue: maxValue?.toString());

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.trim().isEmpty) {
      return newValue;
    }

    final value = double.tryParse(text);
    if (value == null) {
      return oldValue;
    }

    if(_maxValue != null && value > _maxValue && maxValueHint != null){
      Loading.showToast(maxValueHint ?? '');
    }

    return super.formatEditUpdate(oldValue, newValue);
  }
}
