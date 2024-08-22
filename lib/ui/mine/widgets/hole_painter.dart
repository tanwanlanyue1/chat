import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HolePainter extends CustomPainter {
  final Color color;
  final double radius;
  final EdgeInsets padding;

  HolePainter({
    required this.color,
    required this.radius,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 创建一个矩形的路径
    Path rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 创建一个椭圆路径
    Path clipPath = Path()
      ..addRRect(RRect.fromLTRBR(
        padding.left,
        padding.top,
        size.width - padding.left,
        size.height + padding.top,
        Radius.circular(radius),
      ));

    // 将圆形路径从矩形路径中减去，形成挖洞效果
    Path holePath = Path.combine(PathOperation.difference, rectPath, clipPath);

    // 使用画笔绘制路径
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 绘制挖空效果的矩形
    canvas.drawPath(holePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
