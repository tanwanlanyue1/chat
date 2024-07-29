import 'package:flutter/cupertino.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///间距
class Spacing {
  Spacing._();

  static const blank = SizedBox();

  static Widget w(double value) => SizedBox(width: value.rpx);
  static final w4 = w(4);
  static final w8 = w(8);
  static final w12 = w(12);
  static final w16 = w(16);
  static final w24 = w(24);

  static Widget h(double value) => SizedBox(height: value.rpx);
  static final h4 = h(4);
  static final h8 = h(8);
  static final h12 = h(12);
  static final h16 = h(16);
  static final h24 = h(24);
}
