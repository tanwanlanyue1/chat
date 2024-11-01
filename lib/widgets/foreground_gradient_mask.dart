import 'package:flutter/widgets.dart';

///前景渐变遮罩层，可用于文本渐变色等场景
class ForegroundGradientMask extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final bool isMask;

  const ForegroundGradientMask({
    super.key,
    required this.child,
    required this.gradient,
    this.isMask = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isMask) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: gradient.createShader,
        child: child,
      );
    } else {
      return child;
    }
  }
}
