import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///系统状态栏和导航栏样式设置
class SystemUI extends AnnotatedRegion<SystemUiOverlayStyle> {
  const SystemUI({
    super.key,
    required super.child,
    required super.value,
    super.sized,
  });

  factory SystemUI.light({Key? key, required Widget child}) =>
      SystemUI(
        value: SystemUiOverlayStyle.light,
        child: child,
      );

  factory SystemUI.dark({Key? key, required Widget child}) =>
      SystemUI(
        value: SystemUiOverlayStyle.dark,
        child: child,
      );
}
