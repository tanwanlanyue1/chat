import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

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
  final GestureTapCallback? onTapCall;
  final bool showPasswordVisible;
  final Function? callBack;

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
    this.onTapCall,
    this.showPasswordVisible = false,
    this.callBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? 50.rpx;
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius ?? BorderRadius.circular(8.rpx),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
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
              onTap: onTapCall,
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
          ),
          if (showPasswordVisible)
            GestureDetector(
              onTap: (){
                callBack?.call();
              },
              child: Container(
                margin: EdgeInsets.only(right: 4.rpx),
                child: AppImage.asset(
                  obscureText
                      ? "assets/images/common/password_visible.png"
                      : "assets/images/common/password_invisible.png",
                  length: 24.rpx,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
