import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
//滑块
class GradientRangeSliderThumbShape extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(30.rpx, 30.rpx);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = true,
        bool isOnTop = true,
        TextDirection textDirection = TextDirection.ltr,
        required SliderThemeData sliderTheme,
        Thumb thumb = Thumb.start,
        bool isPressed = false,
      }) {
    final Canvas canvas = context.canvas;
    final double radius = 15.rpx;

    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColor.gradientBegin, AppColor.gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.rpx; // Border width

    final Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, borderPaint);
    canvas.drawCircle(center, radius, innerPaint);
  }
}
//滑杆
class CustomRangeSliderTrackShape extends RangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = true,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 4.rpx;
    final double trackWidth = parentBox.size.width;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(offset.dx, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset startThumbCenter,
        required Offset endThumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
      }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint inactiveTrackPaint = Paint()
      ..color = AppColor.gray39
      ..style = PaintingStyle.fill;

    final Paint activeTrackPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColor.gradientBegin, AppColor.gradientEnd],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(trackRect);

    final double activeTrackLeft = (startThumbCenter.dx - offset.dx).clamp(trackRect.left, trackRect.right);
    final double activeTrackRight = (endThumbCenter.dx - offset.dx).clamp(trackRect.left, trackRect.right);

    final Rect activeTrackRect = Rect.fromLTWH(
      activeTrackLeft,
      trackRect.top,
      activeTrackRight - activeTrackLeft,
      trackRect.height,
    );

    canvas.drawRect(trackRect, inactiveTrackPaint);
    if (activeTrackRight > activeTrackLeft) {
      canvas.drawRect(activeTrackRect, activeTrackPaint);
    }
  }
}