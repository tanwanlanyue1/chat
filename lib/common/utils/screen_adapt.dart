import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/file_logger.dart';

///适配像素类工具封装
class ScreenAdapt extends StatelessWidget {
  final WidgetBuilder builder;
  final Size designSize;
  static var _ratio = const Size(1, 1);

  static Size get ratio => _ratio;

  ///屏幕适配
  ///- builder
  ///- designWidth 设计图宽度
  const ScreenAdapt({
    required this.builder,
    required this.designSize,
    super.key,
  });

  static double _rpx(num value) {
    return _rw(value);
  }

  static double _rw(num value) {
    return value * _ratio.width;
  }

  static double _rh(num value) {
    return value * _ratio.height;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.isEmpty) {
      return const SizedBox.shrink();
    }
    _ratio =
        Size(size.width / designSize.width, size.height / designSize.height);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: builder.call(context),
    );
  }
}

/// px单位转换
extension AdaptExtension on num {
  double get rpx => ScreenAdapt._rpx(this);

  double get rw => ScreenAdapt._rw(this);

  double get rh => ScreenAdapt._rh(this);
}
