import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///统一文本样式
class AppTextStyle {

  static const regular = PFTextStyle(fontWeight: FontWeight.w300);
  static const normal = PFTextStyle(fontWeight: FontWeight.w400);
  static const medium = PFTextStyle(fontWeight: FontWeight.w500);
  static const bold = PFTextStyle(fontWeight: FontWeight.bold);

  /// 默认实现 可以配合 TextStyleExtension 拓展 链式调用
  static const st = normal;

  static final fs8r = regular.copyWith(
    fontSize: 8.rpx,
  );

  ///8号字体，字重400
  static final fs8 = normal.copyWith(
    fontSize: 8.rpx,
  );

  ///8号字体，字重500
  static final fs8m = medium.copyWith(
    fontSize: 8.rpx,
  );

  static final fs10r = regular.copyWith(
    fontSize: 10.rpx,
  );

  ///10号字体，字重400
  static final fs10 = normal.copyWith(
    fontSize: 10.rpx,
  );

  ///10号字体，字重500
  static final fs10m = medium.copyWith(
    fontSize: 10.rpx,
  );

  ///10号字体，字重bold
  static final fs10b = bold.copyWith(
    fontSize: 10.rpx,
  );

  ///12号字体，字重300
  static final fs12r = regular.copyWith(
    fontSize: 12.rpx,
  );

  ///12号字体，字重400
  static final fs12 = normal.copyWith(
    fontSize: 12.rpx,
  );

  ///12号字体，字重500
  static final fs12m = medium.copyWith(
    fontSize: 12.rpx,
  );

  ///12号字体，字重bold
  static final fs12b = bold.copyWith(
    fontSize: 12.rpx,
  );

  ///14号字体,字重300
  static final fs14r = regular.copyWith(
    fontSize: 14.rpx,
  );

  ///14号字体,字重400
  static final fs14 = normal.copyWith(
    fontSize: 14.rpx,
  );

  ///14号字体，字重500
  static final fs14m = medium.copyWith(
    fontSize: 14.rpx,
  );

  ///14号字体，字重bold
  static final fs14b = bold.copyWith(
    fontSize: 14.rpx,
  );

  ///16号字体，字重300
  static final fs16r = regular.copyWith(
    fontSize: 16.rpx,
  );

  ///16号字体，字重400
  static final fs16 = normal.copyWith(
    fontSize: 16.rpx,
  );

  ///16号字体，字重500
  static final fs16m = medium.copyWith(
    fontSize: 16.rpx,
  );

  ///16号字体，字重bold
  static final fs16b = bold.copyWith(
    fontSize: 16.rpx,
  );

  ///18号字体，字重300
  static final fs18r = regular.copyWith(
    fontSize: 18.rpx,
  );

  ///18号字体，字重400
  static final fs18 = normal.copyWith(
    fontSize: 18.rpx,
  );

  ///18号字体，字重500
  static final fs18m = medium.copyWith(
    fontSize: 18.rpx,
  );

  ///18号字体，字重bold
  static final fs18b = bold.copyWith(
    fontSize: 18.rpx,
  );

  ///20号字体
  static final fs20r = regular.copyWith(
    fontSize: 20.rpx,
  );

  ///20号字体，字重400
  static final fs20 = normal.copyWith(
    fontSize: 20.rpx,
  );

  ///20号字体，字重500
  static final fs20m = medium.copyWith(
    fontSize: 20.rpx,
  );

  ///20号字体，字重bold
  static final fs20b = bold.copyWith(
    fontSize: 20.rpx,
  );

  ///20号字体
  static final fs22r = regular.copyWith(
    fontSize: 22.rpx,
  );

  ///20号字体，字重400
  static final fs22 = normal.copyWith(
    fontSize: 22.rpx,
  );

  ///20号字体，字重500
  static final fs22m = medium.copyWith(
    fontSize: 22.rpx,
  );

  ///20号字体，字重bold
  static final fs22b = bold.copyWith(
    fontSize: 22.rpx,
  );

  ///24号字体
  static final fs24r = regular.copyWith(
    fontSize: 24.rpx,
  );

  ///24号字体，字重400
  static final fs24 = normal.copyWith(
    fontSize: 24.rpx,
  );

  ///24号字体，字重500
  static final fs24m = medium.copyWith(
    fontSize: 24.rpx,
  );

  ///24号字体，字重bold
  static final fs24b = bold.copyWith(
    fontSize: 24.rpx,
  );
}

///苹方字体样式
class PFTextStyle extends TextStyle {
  const PFTextStyle(
      {super.inherit,
      super.color,
      super.backgroundColor,
      super.fontSize,
      super.fontWeight,
      super.fontStyle,
      super.letterSpacing,
      super.wordSpacing,
      super.textBaseline,
      super.height,
      super.leadingDistribution = TextLeadingDistribution.even,
      super.locale,
      super.foreground,
      super.background,
      super.shadows,
      super.fontFeatures,
      super.fontVariations,
      super.decoration,
      super.decorationColor,
      super.decorationStyle,
      super.decorationThickness,
      super.debugLabel,
      super.package,
      super.overflow,
      super.fontFamilyFallback,
      super.fontFamily = 'PingFang SC'});
}
