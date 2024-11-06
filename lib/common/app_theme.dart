import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'app_constant.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: AppTextStyle.normal.fontFamily,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) {
        final brightness = AppBarTheme.of(context).systemOverlayStyle?.statusBarIconBrightness;
        return AppBackButtonIcon(brightness: brightness);
      },
    ),
    scaffoldBackgroundColor: AppColor.scaffoldBackground,
    primarySwatch: generateMaterialColor(color: AppColor.primary),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xff333333),
      titleTextStyle: AppTextStyle.fs18m.copyWith(color: AppColor.blackBlue),
      centerTitle: true,
      systemOverlayStyle: SystemUI.darkStyle,
      toolbarHeight: kNavigationBarHeight,
    ),
  );

  static final dark = light.copyWith(
    brightness: Brightness.dark,
  );


}
