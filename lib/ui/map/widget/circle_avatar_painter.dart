import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///绘制Marker

class UiImage{
  UiImage._();

  static Future<dynamic> loadImage(String avatar) async {
    File res = await DefaultCacheManager().getSingleFile(avatar);
    Uint8List byteData = await res.readAsBytes();
    Future<ui.Image> img = decodeImageFromList(byteData);
    return img;
  }

  static double getTextWidth({required BuildContext context, required String text, TextStyle? style}) {
    if(text.isEmpty){
      return 0;
    }
    final span = TextSpan(text: text, style: style);

    const constraints = BoxConstraints(maxWidth: double.infinity);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    final boxes = renderObject.getBoxesForSelection(TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: text).toPlainText().length,
    ));

    return boxes.last.right;
  }

  static String nickName(String name,bool sub){
    String nick = name;
    if(sub){
      if(RegExp('[a-zA-Z]').hasMatch(name)){
        if(nick.length < 9){
          return nick;
        }return nick.substring(0,9);
      }else{
        if(nick.length < 5){
          return nick;
        }
        return nick.substring(0,5);
      }
    }
    return nick;
  }

}

class CircleAvatarPainter extends CustomPainter {
  final ui.Image? image;
  final String displayName;
  final Size size;

  CircleAvatarPainter({
    required this.image,
    required this.displayName,
    required this.size
  });

  @override
  void paint(Canvas canvas,Size sizes) async {
    final paintBackground = Paint()..color = Colors.white;
    final RRect roundedRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(4.px),);
    canvas.drawRRect(roundedRect, paintBackground);
    // 计算头像绘制位置和半径
    final double radius = 12.px;
    final Offset circleCenter = Offset(16.px, 18.px);

    // 绘制三角指示器
    final Path trianglePath = Path()
      ..moveTo(size.width / 2 - 8.px, size.height)
      ..lineTo(size.width / 2 + 8.px, size.height)
      ..lineTo(size.width / 2, size.height + 8.px)
      ..close();
    canvas.drawPath(trianglePath, paintBackground);

    // 裁剪区域
    final Path path = Path()..addOval(Rect.fromCircle(center: circleCenter, radius: radius));
    canvas.save();
    canvas.clipPath(path);

    if (image != null) {
      final srcRect = Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble());
      final dstRect = Rect.fromLTWH(4.px, 6.px, 24.px, 24.px);
      canvas.drawImageRect(image!, srcRect, dstRect, Paint());
    }
    canvas.restore();

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14.px,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: displayName, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(32.px, 8.px));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Future<Uint8List> toImage(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)));
    paint(canvas, size);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}