import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///按钮
class Button extends StatelessWidget {
  ///默认背景色
  static const _defaultBackgroundColor = AppColor.gradientBegin;

  static const _defaultOutlineColor = AppColor.gradientBegin;

  static get _defaultBorderRadius => BorderRadius.circular(8.rpx);
  static get _defaultHeight => 50.rpx;

  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool isOutline;
  final OutlinedBorder? shape;
  final VoidCallback? onPressed;

  ///按钮
  ///- child 按钮内容
  ///- borderRadius 圆角
  ///- borderColor isOutline为true时使用的边框颜色
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用状态背景色
  ///- width 按钮宽
  ///- height 按钮高
  ///- constraints 按钮大小约束
  ///- margin 外边距
  ///- padding 内边距
  ///- isOutline 是否是OutlineButton
  ///- onPressed 点击回调
  const Button._({
    super.key,
    this.child,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.padding,
    this.isOutline = false,
    this.shape,
    this.onPressed,
  });

  ///实心按钮
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角,默认8rpx
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        borderRadius: borderRadius ?? _defaultBorderRadius,
        backgroundColor: backgroundColor ?? _defaultBackgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        onPressed: onPressed,
        child: child,
      );

  ///实心按钮（体育场形状）
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button.stadium({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        backgroundColor: backgroundColor ?? _defaultBackgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        shape: const StadiumBorder(),
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        onPressed: onPressed,
        child: child,
      );

  ///边框按钮
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角，默认8rpx
  ///- borderColor 边框色
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button.outline({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        borderRadius: borderRadius ?? _defaultBorderRadius,
        borderColor: borderColor ?? _defaultOutlineColor,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        isOutline: true,
        onPressed: onPressed,
        child: child,
      );

  ///边框按钮（体育场形状）
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角
  ///- borderColor 边框色
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button.outlineStadium({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    Color? borderColor,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        borderColor: borderColor ?? _defaultOutlineColor,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        isOutline: true,
        shape: StadiumBorder(
          side: BorderSide(
            width: 1.rpx,
            color: borderColor ?? _defaultOutlineColor,
          ),
        ),
        onPressed: onPressed,
        child: child,
      );


  ///图标按钮
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button.icon({
    Key? key,
    required Widget icon,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        onPressed: onPressed,
        child: icon,
      );

  ///图片按钮
  ///- child 按钮内容
  ///- width 按钮宽
  ///- height 按钮高
  ///- borderRadius 圆角
  ///- backgroundColor 背景色
  ///- disabledBackgroundColor 禁用时的背景色
  ///- margin 外边距
  ///- padding 内边距
  ///- constraints 按钮大小约束
  ///- onPressed 点击回调
  factory Button.image({
    Key? key,
    required Widget image,
    required Widget child,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) =>
      Button._(
        key: key,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            image,
            child,
          ],
        ),
      );


  @override
  Widget build(BuildContext context) {
    var constraints = this.constraints;
    if (constraints != null) {
      constraints = constraints.copyWith(
        minWidth: width != null ? min(constraints.minWidth, width!) : null,
        minHeight: height != null ? min(constraints.minHeight, height!) : null,
      );
    }
    var backgroundColor = this.backgroundColor;
    var borderColor = this.borderColor;
    var textStyle = AppTextStyle.fs14m.copyWith(
      color: isOutline ? borderColor : Colors.white,
    );
    BoxBorder? border;
    var shape = this.shape;

    if (onPressed == null) {
      backgroundColor =
          disabledBackgroundColor ?? backgroundColor?.withOpacity(0.5);
      textStyle = textStyle.copyWith(
        color: textStyle.color?.withOpacity(0.5),
      );
      borderColor = borderColor?.withOpacity(0.5);
      shape = shape?.copyWith(
        side: shape.side.copyWith(
          color: shape.side.color.withOpacity(0.5),
        )
      );
    }
    if (isOutline && borderColor != null) {
      border = Border.all(
        color: borderColor,
        width: 2.rpx,
      );
    }
    Decoration? decoration;
    if (shape != null) {
      decoration = ShapeDecoration(
        shape: shape,
        color: backgroundColor,
      );
    } else {
      decoration = BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        border: border,
      );
    }

    Widget widget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        width: width,
        height: height ?? _defaultHeight,
        constraints: constraints,
        alignment: Alignment.center,
        decoration: decoration,
        padding: padding,
        child: child != null
            ? DefaultTextStyle(
                style: textStyle,
                child: child!,
              )
            : null,
      ),
    );
    if (margin != null) {
      widget = Padding(
        padding: margin!,
        child: widget,
      );
    }
    return widget;
  }
}
