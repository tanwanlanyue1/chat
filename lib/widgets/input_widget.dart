import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';

///输入框
///disabled:启用
///isPassWord: 是否密码
///filled:填充的背景色
///hintText:提示的值
///hintVal:默认值
///onChanged:回调
///TextInputType 键盘类型
class InputWidget extends StatelessWidget {
  final bool? disabled;
  final Color? fillColor;
  final bool isPassWord;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? counterStyle;
  final TextAlign? textAlign;
  final String hintVal;
  final int lines;
  final int? maxLength;
  final String? counterText;
  final InputBorder? border;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textAction;
  final Function(String val)? onChanged;
  final TextEditingController? inputController;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  InputWidget({
    super.key,
    this.disabled,
    this.fillColor,
    this.isPassWord = false,
    this.hintText,
    this.hintVal = '',
    this.lines = 1,
    this.textStyle,
    this.hintStyle,
    this.textAlign,
    this.maxLength,
    this.counterText,
    this.keyboardType,
    this.focusNode,
    this.border,
    this.onChanged,
    this.textAction,
    this.inputController,
    this.contentPadding,
    this.inputFormatters,
    this.counterStyle,
  });

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            enabled: disabled,
            decoration: InputDecoration(
              hintText: hintText ?? S.current.pleaseInput,
              hintStyle: hintStyle ??
                  TextStyle(
                    color: const Color(0XFF999999),
                    fontSize: 14.rpx,
                  ),
              contentPadding:
                  contentPadding ?? EdgeInsets.symmetric(horizontal: 8.rpx),
              filled: true,
              counterText: counterText,
              fillColor: fillColor ?? const Color(0XffF5F6FA),
              focusedBorder: border ?? InputBorder.none,
              enabledBorder: border ?? InputBorder.none,
              border: border ?? InputBorder.none,
              counterStyle: counterStyle
            ),
            textAlign: textAlign ?? TextAlign.left,
            maxLines: lines,
            maxLength: maxLength,
            focusNode: focusNode,
            controller: inputController ?? controller,
            onChanged: (val) {
              onChanged?.call(val);
            },
            keyboardType: keyboardType ?? TextInputType.text,
            textInputAction: textAction ?? TextInputAction.none,
            obscureText: isPassWord,
            style: textStyle ?? TextStyle(
              color: const Color(0XFF2E2F33),
              fontSize: 14.rpx,
            ),
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }
}
