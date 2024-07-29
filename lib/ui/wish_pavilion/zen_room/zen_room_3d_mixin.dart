import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'widigets/zen_room_gift_panel.dart';

mixin ZenRoom3DMixin on GetxController {
  /// 水平方向最大的旋转角度
  final double _maxAngleX = 30;

  /// 竖直方向最大的旋转角度
  final double _maxAngleY = 80;

  /// 背景层缩放比
  final double backgroundScale = 1.2;
  final double foregroundScale = 1.03;
  Size? _buddhaArea;

  final backgroundOffsetRx = const Offset(0.0, 0.0).obs;
  final foregroundOffsetRx = const Offset(0.0, 0.0).obs;
  final _time = 0.02;
  StreamSubscription? sensorSubscription;

  @override
  void onClose() {
    super.onClose();
    stopSensor();
  }

  ///停止监听传感器
  void stopSensor() {
    sensorSubscription?.cancel();
    sensorSubscription = null;
    backgroundOffsetRx.value = Offset.zero;
    foregroundOffsetRx.value = Offset.zero;
  }

  ///开始监听传感器
  var origin = Offset.zero;
  void startSensor() {
    sensorSubscription?.cancel();
    sensorSubscription =
        gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval)
            .listen((event) {
      // 通过采集的旋转速度计算出背景 delta 偏移
      Offset deltaOffset = _gyroscopeToOffset(-event.y, -event.x);
      // 初始偏移量 + delta 偏移 之后考虑越界
      origin = deltaOffset + origin;
      backgroundOffsetRx.value = getFixOffset(origin);
      // 前景计算相对速度之后取反即可
      foregroundOffsetRx.value = _getForegroundOffset(backgroundOffsetRx());
    });
  }

  Offset _gyroscopeToOffset(double x, double y) {
    double angleX = x * _time * 180 / pi;
    double angleY = y * _time * 180 / pi;
    angleX = angleX >= _maxAngleX ? _maxAngleX : angleX;
    angleY = angleY >= _maxAngleY ? _maxAngleY : angleY;

    return Offset((angleX / _maxAngleX) * _maxBackgroundOffset.dx,
        (angleY / _maxAngleY) * _maxBackgroundOffset.dy);
  }

  Offset getFixOffset(Offset origin){
    var diffX = 0.0;
    var diffY = 0.0;
    if (origin.dx > _maxBackgroundOffset.dx) {
      diffX = origin.dx - _maxBackgroundOffset.dx;
    }else if (origin.dx < -_maxBackgroundOffset.dx) {
      diffX = origin.dx + _maxBackgroundOffset.dx;
    }

    if (origin.dy > _maxBackgroundOffset.dy) {
      diffY = origin.dy - _maxBackgroundOffset.dy;
    }else if (origin.dy < -_maxBackgroundOffset.dy) {
      diffY = origin.dy + _maxBackgroundOffset.dy;
    }
    return origin - Offset(diffX, diffY);
  }

  // 通过最大偏移约束计算偏移量
  Offset _considerBoundary(Offset origin) {
    Offset maxOffset = _maxBackgroundOffset;
    double dx = origin.dx;
    double dy = origin.dy;
    if (dx > maxOffset.dx) {
      dx = maxOffset.dx;
    }
    if (origin.dx < -maxOffset.dx) {
      dx = -maxOffset.dx;
    }

    if (dy > maxOffset.dy) {
      dy = maxOffset.dy;
    }
    if (origin.dy < -maxOffset.dy) {
      dy = -maxOffset.dy;
    }
    Offset result = Offset(dx, dy);
    return result;
  }

  // 背景层的最大偏移
  Offset get _maxBackgroundOffset {
    return Offset(
      (backgroundScale - 1.0) * buddhaArea.width / 2,
      (backgroundScale - 1.0) * buddhaArea.height / 2,
    );
  }

  // 通过背景偏移计算前景偏移
  Offset _getForegroundOffset(Offset backgroundOffset) {
    // 假如前景缩放比是 1.4 背景是 1.8 控件宽度为 10
    // 那么前景最大移动 4 像素，背景最大 8 像素
    double offsetRate = (foregroundScale - 1) / (backgroundScale - 1);
    // 前景取反
    return -Offset(
      backgroundOffset.dx * offsetRate,0,
      // backgroundOffset.dy * offsetRate,
    );
  }

  ///佛像区域大小
  Size get buddhaArea {
    final appbarHeight = kToolbarHeight + Get.mediaQuery.padding.top;
    final bottomHeight = ZenRoomGiftPanel.height;
    return _buddhaArea ??= Size(
      Get.width,
      Get.height - appbarHeight - bottomHeight,
    );
  }
}
