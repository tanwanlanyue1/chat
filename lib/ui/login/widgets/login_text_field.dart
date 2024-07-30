import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    super.key,
    this.controller,
    this.obscureText,
    this.labelText,
    this.hintText,
    this.keyboardType,
  });

  final TextEditingController? controller;

  final bool? obscureText;

  final String? labelText;

  final String? hintText;

  final TextInputType? keyboardType;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Container(
        height: 54.rpx,
        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: widget.controller,
          focusNode: focusNode,
          obscureText: widget.obscureText ?? false,
          keyboardType: widget.keyboardType,
          style: AppTextStyle.st.medium.size(14.rpx).textColor(AppColor.black3),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: AppTextStyle.st.medium.textColor(AppColor.black92),
            hintText: widget.hintText,
            hintStyle: AppTextStyle.st.medium.textColor(AppColor.black92),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
