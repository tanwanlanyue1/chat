import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'dart:ui' as ui;

//滑块
class GradientRangeSliderThumbShape extends RangeSliderThumbShape {

  static ui.Image? _thumbLabelImage;
  static ui.Image? _thumbImage;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(30.rpx, 18.rpx);
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
  }) async{
    final Canvas canvas = context.canvas;

    final thumbLabel = _thumbLabelImage ??= await loadUiImage('assets/images/common/ic_slider_label.png');
    var src = Rect.fromLTWH(0, 0, thumbLabel.width.toDouble(), thumbLabel.height.toDouble());
    var dst = Rect.fromCenter(center: center.translate(0, -src.height/4-4.rpx), width: thumbLabel.width.toDouble()/4, height: thumbLabel.height.toDouble()/4);
    // canvas.drawImageRect(thumbLabel, src, dst, Paint());

    final thumb = _thumbImage ??= await loadUiImage('assets/images/common/ic_slider_thumb.png');
    src = Rect.fromLTWH(0, 0, thumb.width.toDouble(), thumb.height.toDouble());
    dst = Rect.fromCenter(center: center, width: thumb.width.toDouble()/4, height: thumb.height.toDouble()/4);
    canvas.drawImageRect(thumb, src, dst, Paint());



  }


  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
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
    final double trackHeight = 6.rpx;
    final double trackWidth = parentBox.size.width;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
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
      ..color = AppColor.primaryBlue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final Paint activeTrackPaint = Paint()
    ..color = AppColor.primaryBlue;
      // ..shader = const LinearGradient(
      //   colors: [AppColor.gradientBegin, AppColor.gradientEnd],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ).createShader(trackRect);

    final double activeTrackLeft = (startThumbCenter.dx - offset.dx)
        .clamp(trackRect.left, trackRect.right);
    final double activeTrackRight =
        (endThumbCenter.dx - offset.dx).clamp(trackRect.left, trackRect.right);

    final Rect activeTrackRect = Rect.fromLTWH(
      activeTrackLeft,
      trackRect.top,
      activeTrackRight - activeTrackLeft,
      trackRect.height,
    );

    canvas.drawRRect(
        RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height)),
        inactiveTrackPaint);
    // canvas.drawRect(trackRect, inactiveTrackPaint);
    if (activeTrackRight > activeTrackLeft) {
      canvas.drawRect(activeTrackRect, activeTrackPaint);
    }
  }
}
