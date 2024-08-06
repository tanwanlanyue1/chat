import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

/// 项目通用的渐变色按钮
/// onTap 点击事件
/// text 按钮文字
/// textStyle 按钮文字样式 默认为 AppTextStyle.st.medium.size(14.rpx).textColor(Colors.white)
/// width 按钮宽度
/// height 按钮高度
/// padding 按钮内边距
/// borderRadius 圆角 默认为 all 8.rpx
/// begin 渐变开始位置 默认为 Alignment.topLeft
/// end 渐变结束位置 默认为 Alignment.bottomRight
class CommonGradientButton extends StatelessWidget {
  const CommonGradientButton({
    super.key,
    this.onTap,
    this.text,
    this.textStyle,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.begin,
    this.end,
    this.widget,
  });

  final VoidCallback? onTap;
  final String? text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8.rpx),
            gradient: LinearGradient(
              begin: begin ?? Alignment.topLeft,
              end: end ?? Alignment.bottomRight,
              colors: const [
                AppColor.gradientBegin,
                AppColor.gradientEnd,
              ],
            )),
        alignment: Alignment.center,
        child: widget ?? Text(
          text ?? "",
          style: textStyle ??
              AppTextStyle.st.medium.size(16.rpx).textColor(Colors.white),
        ),
      ),
    );
  }
}
