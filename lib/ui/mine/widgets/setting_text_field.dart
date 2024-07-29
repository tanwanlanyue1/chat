import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class SettingTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final double? height;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? inputController;
  final bool obscureText;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const SettingTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.inputFormatters,
    this.inputController,
    this.obscureText = false,
    this.readOnly = false,
    this.height,
    this.contentPadding,
    this.keyboardType,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? 46.rpx;
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius ?? BorderRadius.circular(8.rpx),
        color: Colors.white,
      ),
      child: TextField(
        readOnly: readOnly,
        controller: inputController,
        cursorColor: Colors.black,
        maxLines: 1,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14.rpx,),
        inputFormatters: inputFormatters,
        obscuringCharacter: '*',
        obscureText: obscureText,
        onChanged: (val){},
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minHeight: height),
          prefixIcon: labelText != null ? Padding(
            padding: EdgeInsets.only(left: 12.rpx, right: 8.rpx),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(labelText??'', style: TextStyle(fontSize: 15.rpx, color: Color(0xff333333)))
              ],
            ),
          ) : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff999999)),
          contentPadding: contentPadding,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: suffixIcon ?? SizedBox(),
          suffixIconConstraints: BoxConstraints.tightFor(height: height),
          counterText: '',
        ),
      ),
    );
  }
}
