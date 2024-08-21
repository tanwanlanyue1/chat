import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///统一文本样式
class AppTextStyle {
  AppTextStyle._();

  static const pingFangMedium = TextStyle(
    fontFamily: 'PingFang-Medium',
  );
  
  static const pingFangRegular = TextStyle(
    fontFamily: 'PingFang-Regular',
  );
  
  static const pingFangBold = TextStyle(
    fontFamily: 'PingFang-Bold',
  );
  
  /// 默认实现 可以配合 TextStyleExtension 拓展 链式调用
  static const st = pingFangMedium;

  ///10号字体，字重500
  static final fs10r = pingFangRegular.copyWith(
    fontSize: 10.rpx,
  );

  ///10号字体，字重500
  static final fs10m = pingFangMedium.copyWith(
    fontSize: 10.rpx,
  );

  ///10号字体，字重bold
  static final fs10b = pingFangBold.copyWith(
    fontSize: 10.rpx,
  );

  ///11号字体
  static final fs11r = pingFangRegular.copyWith(
    fontSize: 11.rpx,
  );

  ///11号字体，字重500
  static final fs11m = pingFangMedium.copyWith(
    fontSize: 11.rpx,
    fontWeight: FontWeight.w500,
  );

  ///11号字体，字重bold
  static final fs11b = pingFangBold.copyWith(
    fontSize: 11.rpx,
  );

  ///12号字体
  static final fs12r = pingFangRegular.copyWith(
    fontSize: 12.rpx,
  );

  ///12号字体，字重500
  static final fs12m = pingFangMedium.copyWith(
    fontSize: 12.rpx,
    fontWeight: FontWeight.w500,
  );

  ///12号字体，字重bold
  static final fs12b = pingFangBold.copyWith(
    fontSize: 12.rpx,
  );

  ///13号字体
  static final fs13r = pingFangRegular.copyWith(
    fontSize: 13.rpx,
  );

  ///13号字体，字重500
  static final fs13m = pingFangMedium.copyWith(
    fontSize: 13.rpx,
    fontWeight: FontWeight.w500,
  );

  ///13号字体，字重bold
  static final fs13b = pingFangBold.copyWith(
    fontSize: 13.rpx,
  );

  ///14号字体
  static final fs14r = pingFangRegular.copyWith(
    fontSize: 14.rpx,
  );

  ///14号字体，字重500
  static final fs14m = pingFangMedium.copyWith(
    fontSize: 14.rpx,
    fontWeight: FontWeight.w500,
  );

  ///14号字体，字重bold
  static final fs14b = pingFangBold.copyWith(
    fontSize: 14.rpx,
  );

  ///15号字体
  static final fs15r = pingFangRegular.copyWith(
    fontSize: 15.rpx,
  );

  ///15号字体，字重500
  static final fs15m = pingFangMedium.copyWith(
    fontSize: 15.rpx,
    fontWeight: FontWeight.w500,
  );

  ///15号字体，字重bold
  static final fs15b = pingFangBold.copyWith(
    fontSize: 15.rpx,
  );

  ///16号字体
  static final fs16r = pingFangRegular.copyWith(
    fontSize: 16.rpx,
  );

  ///16号字体，字重500
  static final fs16m = pingFangMedium.copyWith(
    fontSize: 16.rpx,
    fontWeight: FontWeight.w500,
  );

  ///16号字体，字重bold
  static final fs16b = pingFangBold.copyWith(
    fontSize: 16.rpx,
  );

  ///18号字体
  static final fs18r = pingFangRegular.copyWith(
    fontSize: 18.rpx,
  );

  ///18号字体，字重500
  static final fs18m = pingFangMedium.copyWith(
    fontSize: 18.rpx,
    fontWeight: FontWeight.w500,
  );

  ///18号字体，字重bold
  static final fs18b = pingFangBold.copyWith(
    fontSize: 18.rpx,
  );

  ///19号字体
  static final fs19r = pingFangRegular.copyWith(
    fontSize: 19.rpx,
  );

  ///19号字体，字重500
  static final fs19m = pingFangMedium.copyWith(
    fontSize: 19.rpx,
    fontWeight: FontWeight.w500,
  );

  ///19号字体，字重bold
  static final fs19b = pingFangBold.copyWith(
    fontSize: 19.rpx,
  );

  ///20号字体
  static final fs20r = pingFangRegular.copyWith(
    fontSize: 20.rpx,
  );

  ///20号字体，字重500
  static final fs20m = pingFangMedium.copyWith(
    fontSize: 20.rpx,
    fontWeight: FontWeight.w500,
  );

  ///20号字体，字重bold
  static final fs20b = pingFangBold.copyWith(
    fontSize: 20.rpx,
  );

  ///22号字体
  static final fs22r = pingFangRegular.copyWith(
    fontSize: 22.rpx,
  );

  ///22号字体，字重bold
  static final fs22b = pingFangBold.copyWith(
    fontSize: 22.rpx,
  );

  ///24号字体
  static final fs24r = pingFangRegular.copyWith(
    fontSize: 24.rpx,
  );

  ///24号字体，字重500
  static final fs24m = pingFangMedium.copyWith(
    fontSize: 24.rpx,
    fontWeight: FontWeight.w500,
  );

  ///26号字体
  static final fs26r = pingFangRegular.copyWith(
    fontSize: 26.rpx,
  );

  ///26号字体，字重bold
  static final fs26b = pingFangBold.copyWith(
    fontSize: 26.rpx,
  );


  ///30号字体，字重bold
  static final fs30b = pingFangBold.copyWith(
    fontSize: 30.rpx,
  );

  ///32号字体，字重500
  static final fs32m = pingFangMedium.copyWith(
    fontSize: 32.rpx,
    fontWeight: FontWeight.w500,
  );

}

///字体
class AppFontFamily {
  const AppFontFamily._();
}
