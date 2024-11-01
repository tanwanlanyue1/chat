import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'app_image.dart';
import 'edge_insets.dart';

typedef OnDraggingCallback = void Function(double leftValue, double rightValue);

///区域滑动条
class RangeSliderBar extends StatelessWidget {
  final double min;
  final double max;
  final double leftValue;
  final double rightValue;
  final OnDraggingCallback? onDragging;

  const RangeSliderBar({
    super.key,
    required this.min,
    required this.max,
    required this.leftValue,
    required this.rightValue,
    this.onDragging,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [
        leftValue,
        rightValue,
      ],
      rangeSlider: true,
      min: min,
      max: max,
      trackBar: FlutterSliderTrackBar(
        activeTrackBar: BoxDecoration(
          color: AppColor.primaryBlue,
          borderRadius: BorderRadius.circular(2.rpx),
        ),
        inactiveTrackBar: BoxDecoration(
          color: AppColor.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(2.rpx),
        ),
        activeTrackBarHeight: 4.rpx,
        inactiveTrackBarHeight: 4.rpx,
      ),
      handlerAnimation: const FlutterSliderHandlerAnimation(),
      handlerHeight: 18.rpx,
      handlerWidth: 30.rpx,
      handler: FlutterSliderHandler(
        child: AppImage.asset(
          'assets/images/common/ic_slider_thumb.png',
          width: 30.rpx,
          height: 18.rpx,
        ),
        decoration: const BoxDecoration(),
      ),
      rightHandler: FlutterSliderHandler(
        child: AppImage.asset(
          'assets/images/common/ic_slider_thumb.png',
          width: 30.rpx,
          height: 18.rpx,
        ),
        decoration: const BoxDecoration(),
      ),
      tooltip: FlutterSliderTooltip(
        alwaysShowTooltip: true,
        custom: (value) {
          final val = double.tryParse(value.toString()) ?? 0;
          return Container(
            width: 22.rpx,
            height: 22.rpx,
            padding: FEdgeInsets(top: 2.5.rpx),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AppAssetImage('assets/images/common/ic_slider_label.png'),
              ),
            ),
            child: Text(
              val.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: AppTextStyle.fs12.copyWith(
                color: AppColor.primaryBlue,
                height: 1.0,
              ),
            ),
          );
        },
        direction: FlutterSliderTooltipDirection.top,
        positionOffset: FlutterSliderTooltipPositionOffset(top: -18.rpx),
      ),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        final leftValue = double.tryParse(lowerValue.toString()) ?? 0;
        final rightValue = double.tryParse(upperValue.toString()) ?? 0;
        onDragging?.call(leftValue, rightValue);
      },
    );
  }
}
