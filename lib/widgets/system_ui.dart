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

  static SystemUiOverlayStyle get lightStyle {
    return SystemUiOverlayStyle.light.transparentSystemNavigationBar();
  }

  static SystemUiOverlayStyle get darkStyle {
    return SystemUiOverlayStyle.dark.transparentSystemNavigationBar();
  }

  factory SystemUI.light({Key? key, required Widget child}) =>
      SystemUI(
        value: lightStyle,
        child: child,
      );

  factory SystemUI.dark({Key? key, required Widget child}) =>
      SystemUI(
        value: darkStyle,
        child: child,
      );
}

extension SystemUiOverlayStyleExt on SystemUiOverlayStyle{
  ///透明底部系统导航栏
  SystemUiOverlayStyle transparentSystemNavigationBar(){
    return copyWith(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
    );
  }
}
