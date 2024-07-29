import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';

import '../widgets/app_image.dart';
class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: AppTextStyle.notoSerifSC.fontFamily,
    fontFamilyFallback: const ['Roboto'],
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) {
        final brightness = AppBarTheme.of(context).systemOverlayStyle?.statusBarIconBrightness;
        return AppBackButtonIcon(brightness: brightness);
      },
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xff333333),
      titleTextStyle: AppTextStyle.notoSerifSC.copyWith(
        color: const Color(0xff333333),
        fontSize: 18.rpx,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );

  static final dark = light.copyWith(
    brightness: Brightness.dark,
  );


}
