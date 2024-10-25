import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///统一文本样式
class AppTextStyle{

  static const normal = TextStyle(leadingDistribution: TextLeadingDistribution.even);
  static final regular = normal.copyWith(fontWeight: FontWeight.w100);
  static final medium = normal.copyWith(fontWeight: FontWeight.w500);
  static final bold = normal.copyWith(fontWeight: FontWeight.bold);

  /// 默认实现 可以配合 TextStyleExtension 拓展 链式调用
  static const st = normal;

  ///10号字体，字重500
  static final fs10r = regular.copyWith(
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

  ///11号字体
  static final fs11r = regular.copyWith(
    fontSize: 11.rpx,
  );

  ///11号字体，字重500
  static final fs11m = medium.copyWith(
    fontSize: 11.rpx,
    fontWeight: FontWeight.w500,
  );

  ///11号字体，字重bold
  static final fs11b = bold.copyWith(
    fontSize: 11.rpx,
  );

  ///12号字体
  static final fs12r = regular.copyWith(
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

  ///13号字体
  static final fs13r = regular.copyWith(
    fontSize: 13.rpx,
  );

  ///13号字体，字重500
  static final fs13m = medium.copyWith(
    fontSize: 13.rpx,
  );

  ///13号字体，字重bold
  static final fs13b = bold.copyWith(
    fontSize: 13.rpx,
  );

  ///14号字体
  static final fs14r = regular.copyWith(
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

  ///15号字体
  static final fs15r = regular.copyWith(
    fontSize: 15.rpx,
  );

  ///15号字体，字重500
  static final fs15m = medium.copyWith(
    fontSize: 15.rpx,
  );

  ///15号字体，字重bold
  static final fs15b = bold.copyWith(
    fontSize: 15.rpx,
  );

  ///16号字体
  static final fs16r = regular.copyWith(
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

  ///18号字体
  static final fs18r = regular.copyWith(
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

  ///19号字体
  static final fs19r = regular.copyWith(
    fontSize: 19.rpx,
  );

  ///19号字体，字重500
  static final fs19m = medium.copyWith(
    fontSize: 19.rpx,
  );

  ///19号字体，字重bold
  static final fs19b = bold.copyWith(
    fontSize: 19.rpx,
  );

  ///20号字体
  static final fs20r = regular.copyWith(
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

  ///22号字体
  static final fs22r = regular.copyWith(
    fontSize: 22.rpx,
  );

  ///22号字体，字重bold
  static final fs22b = bold.copyWith(
    fontSize: 22.rpx,
  );

  ///24号字体
  static final fs24r = regular.copyWith(
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

  ///26号字体
  static final fs26r = regular.copyWith(
    fontSize: 26.rpx,
  );

  ///26号字体，字重bold
  static final fs26b = bold.copyWith(
    fontSize: 26.rpx,
  );

  ///30号字体，字重bold
  static final fs30b = bold.copyWith(
    fontSize: 30.rpx,
  );

  ///32号字体，字重500
  static final fs32m = medium.copyWith(
    fontSize: 32.rpx,
  );
}

///苹方字体样式
class PFTextStyle extends TextStyle {
  static const _fontRegular = 'PingFang-Regular';
  static const _fontMedium = 'PingFang-Medium';
  static const _fontBold = 'PingFang-Bold';

  static String? _getFontFamily(FontWeight? fontWeight) {
    if (fontWeight != null) {
      if (fontWeight.value < 500) {
        return _fontRegular;
      } else if (fontWeight.value == 500) {
        return _fontMedium;
      } else {
        return _fontBold;
      }
    }
    return null;
  }

  const PFTextStyle({
    super.inherit,
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
    super.fontFamily,
  });

  //: super(fontFamily: _getFontFamily(fontWeight))

  factory PFTextStyle.regular() {
    return PFTextStyle(
      fontWeight: FontWeight.w400,
    );
  }

  factory PFTextStyle.medium() {
    return PFTextStyle(
      fontWeight: FontWeight.w500,
    );
  }

  factory PFTextStyle.bold() {
    return PFTextStyle(
      fontWeight: FontWeight.bold,
    );
  }
//
// @override
// TextStyle copyWith({
//   bool? inherit,
//   Color? color,
//   Color? backgroundColor,
//   double? fontSize,
//   FontWeight? fontWeight,
//   FontStyle? fontStyle,
//   double? letterSpacing,
//   double? wordSpacing,
//   TextBaseline? textBaseline,
//   double? height,
//   TextLeadingDistribution? leadingDistribution,
//   Locale? locale,
//   Paint? foreground,
//   Paint? background,
//   List<Shadow>? shadows,
//   List<FontFeature>? fontFeatures,
//   List<FontVariation>? fontVariations,
//   TextDecoration? decoration,
//   Color? decorationColor,
//   TextDecorationStyle? decorationStyle,
//   double? decorationThickness,
//   String? debugLabel,
//   String? fontFamily,
//   List<String>? fontFamilyFallback,
//   String? package,
//   TextOverflow? overflow,
// }) {
//   return super.copyWith(
//     inherit: inherit,
//     color: color,
//     backgroundColor: backgroundColor,
//     fontSize: fontSize,
//     fontWeight: fontWeight,
//     fontStyle: fontStyle,
//     letterSpacing: letterSpacing,
//     wordSpacing: wordSpacing,
//     textBaseline: textBaseline,
//     height: height,
//     leadingDistribution: leadingDistribution,
//     locale: locale,
//     foreground: foreground,
//     background: background,
//     shadows: shadows,
//     fontFeatures: fontFeatures,
//     fontVariations: fontVariations,
//     decoration: decoration,
//     decorationColor: decorationColor,
//     decorationStyle: decorationStyle,
//     decorationThickness: decorationThickness,
//     debugLabel: debugLabel,
//     fontFamily: _getFontFamily(fontWeight),
//     fontFamilyFallback: fontFamilyFallback,
//     package: package,
//     overflow: overflow,
//   );
// }
}
