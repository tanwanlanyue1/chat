import 'package:flutter/material.dart';

/// 项目中使用到的颜色
/// 透明色建议直接使用 withOpacity 直接设置
/// 同种类颜色尽量规范命名
/// 例如：gray6 = 0xFF666666, gray9 = 0xFF999999，grayE6 = 0xFFE6E6E6
class AppColor {
  const AppColor._();

  /// 主色
  static const primary = Color(0xFF3699FF);

  /// 界面背景色
  static const scaffoldBackground = Color(0xFFF8F9FE);

  /// 黑灰色
  static const black3 = Color(0xFF333333);
  static const black6 = Color(0xFF666666);
  static const black9 = Color(0xFF999999);
  static const black92 = Color(0xFF929DB2);
  static const black1A = Color(0x1A929DB2);
  static const black4E = Color(0xFF4E4E4E);
  static const black20 = Color(0xFF020635);
  static const black22 = Color(0xB2020635);

  /// 按钮渐变色
  static const gradientBegin = Color(0xff0F73ED);
  static const gradientEnd = Color(0xffC538FF);

  static const gradientBackgroundBegin = Color(0xff226EF0);
  static const gradientBackgroundEnd = Color(0xffBD3CFF);

  /// 文本特殊颜色
  static const textYellow = Color(0xFFF7BF4B);
  static const textRed = Color(0xFFE5393C);
  static const textPurple = Color(0xFFC644FC);
  static const textBlue = Color(0xFF4166F2);
  static const textGreen = Color(0xFF3CB236);

  /// old
  static const gray1 = Color(0x38FFFFFF);
  static const gray2 = Color(0x99FFFFFF);
  static const gray3 = Color(0xCCFFFFFF);
  static const gray4 = Color(0x66FFFFFF);
  static const gray5 = Color(0xFF333333);
  static const gray6 = Color(0x54FFFFFF);
  static const gray7 = Color(0xB3000000);
  static const gray8 = Color(0xFF000000);
  static const gray40 = Color(0x4D000000);
  static const gray33 = Color(0x33000000);
  static const gray11 = Color(0x1A000000);
  static const gray9 = Color(0xFF999999);
  static const gray91 = Color(0xFFE9E9E9);
  static const gray99 = Color(0x1A999999);
  static const gray10 = Color(0xFFBBBBBB);
  static const gray12 = Color(0xffE6E6E6);
  static const gray13 = Color(0xFFF7EFE3);
  static const gray14 = Color(0xFFF6F6F6);
  static const gray19 = Color(0xffF5F1E9);
  static const gray20 = Color(0xffE8E7E9);
  static const gray30 = Color(0xff666666);
  static const gray39 = Color(0x33999999);
  static const gray80 = Color(0x80999999);
  static const grayF7 = Color(0xFFF7F7F7);

  static const white8 = Color(0xFFF8F9FE);

  static const blue3 = Color(0xFF4754B3);
  static const blue6 = Color(0xFF4166F2);
  static const blue36 = Color(0x1A3699FF);
  static const blue56 = Color(0xFF4B5672);

  static const gold = Color(0xFFFFCD4D);
  static const gold1 = Color(0xFFDE9A22);
  static const gold5 = Color(0xFFF9E5BB);
  static const gold7 = Color(0xFFFFF1D5);
  static const gold8 = Color(0xFFFFD47F);
  static const gold9 = Color(0xFFF5ECD9);

  static const brown = Color(0x695F2C11);
  static const brown1 = Color(0xFFFFDABB);
  static const brown2 = Color(0xFFFFFCF7);
  static const brown3 = Color(0xFFF7EDE3);
  static const brown4 = Color(0xFF895F25);
  static const brown5 = Color(0xFFC3A77B);
  static const brown6 = Color(0xFFC69B60);
  static const brown7 = Color(0xFF652705);
  static const brown8 = Color(0x1A8D310F);
  static const brown9 = Color(0x809A6C1B);
  static const brown10 = Color(0xFF512F00);
  static const brown11 = Color(0xFF6C490F);
  static const brown12 = Color(0xFFECD7B8);
  static const brown13 = Color(0xFFD48651);
  static const brown14 = Color(0xFFF8F3E8);
  static const brown21 = Color(0xFF3B2121);
  static const brown26 = Color(0xFF684326);
  static const brown27 = Color(0x1A684326);
  static const brown28 = Color(0xFFEEC88A);
  static const brown32 = Color(0xFFF0D2AC);
  static const brown34 = Color(0x80967336);
  static const brown35 = Color(0xFFFFF4E5);
  static const brown36 = Color(0xFF967336);
  static const brown37 = Color(0x33967336);
  static const brown38 = Color(0xFFE8DDCB);
  static const brown39 = Color(0xFFFFF9EB);
  static const brown40 = Color(0xFFF9E5BA);
  static const brown41 = Color(0x4DF9E5BA);
  static const brown42 = Color(0xFFFFD980);
  static const brown43 = Color(0xFFFFECBF);

  static const red1 = Color(0xFF8D310F);
  static const red7 = Color(0xFFC41717);
  static const red6 = Color(0xFFF23030);
  static const red8 = Color(0xFF8B383C);
  static const red53 = Color(0xffE5393C);
  static const red58 = Color(0xFFCC5258);

  static const green2 = Color(0xff2E9959);

  static const purple6 = Color(0xffC644FC);
  static const orange6 = Color(0xFFFA9D3B);

  ///主色渐变色(水平渐变)
  static const horizontalGradient = LinearGradient(
    colors: [Color(0xFF0F73ED), Color(0xFFC538FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  ///背景渐变色(垂直渐变)
  static const verticalGradient = LinearGradient(
    colors: [Color(0xFF226EF0), Color(0xFFBD3CFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );


  ///主色蓝色(社区蓝色)
  static const primaryBlue = Color(0xFF0F73ED);

  ///浅蓝色按钮
  static const babyBlueButton = Color(0xFF3699FF);

  ///约会按钮
  static const dateButton = Color(0xFFC644FC);

  ///灰色字体
  static const grayText = Color(0xFF929DB2);

  ///红色
  static const red = Color(0xFFE5393C);

  ///黄色
  static const yellow = Color(0xFFF7BF4B);

  ///绿色
  static const green = Color(0xFF3CB236);

  ///转账红包
  static const redPacket = Color(0xFFFA9D3B);

  ///黑色字体带点蓝
  static const blackBlue = Color(0xFF020635);

  ///tab色
  static const tab = Color(0xFF4B5672);

  ///背景色
  static const background = Color(0xFFF8F9FE);

  ///背景色-灰
  static const grayBackground = Color(0xFFF7F7F7);

  ///黑色字体
  static const backText = Color(0xFF4E4E4E);

  ///999
  static const black999 = Color(0xFF999999);

  ///666
  static const black666 = Color(0xFF666666);

}
