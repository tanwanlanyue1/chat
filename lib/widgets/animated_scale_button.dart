import 'package:flutter/material.dart';

///缩放动画按钮
class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double scale;
  final Duration duration;
  final VoidCallback? onTap;

  const AnimatedScaleButton({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.scale = 1.2,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        setState(() {
          scale = widget.scale;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedScale(
          scale: scale,
          duration: widget.duration,
          onEnd: () {
            if (scale != 1.0) {
              setState(() {
                scale = 1.0;
              });
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
