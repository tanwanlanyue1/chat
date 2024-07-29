import 'package:flutter/material.dart';

import 'app_image.dart';

///返回按钮
class AppBackButton extends StatelessWidget {
  final Brightness? brightness;

  const AppBackButton({super.key, this.brightness});

  factory AppBackButton.light() =>
      const AppBackButton(brightness: Brightness.light);

  factory AppBackButton.dark() =>
      const AppBackButton(brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: Navigator.of(context).maybePop,
      icon: AppBackButtonIcon(brightness: brightness),
    );
  }
}

///返回按钮图标
class AppBackButtonIcon extends StatelessWidget {
  final Brightness? brightness;

  const AppBackButtonIcon({super.key, this.brightness});

  @override
  Widget build(BuildContext context) {
    // AppBarTheme.of(context).systemOverlayStyle.systemNavigationBarIconBrightness;
    return AppImage.asset(
      width: 24,
      height: 24,
      brightness == Brightness.dark
          ? 'assets/images/common/ic_back_black.png'
          : 'assets/images/common/ic_back_white.png',
    );
  }
}
