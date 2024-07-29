import 'package:flutter/material.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///字幕行文本
class ChantSutrasLineTile extends StatelessWidget {
  final String text;
  final bool isHighlight;

  const ChantSutrasLineTile({
    super.key,
    required this.text,
    this.isHighlight = false,
  });

  static double get height => 34.rpx;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: AppTextStyle.notoSerifSC.copyWith(
          fontSize: isHighlight ? 20.rpx : 16.rpx,
          fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
          color:
          isHighlight ? const Color(0xFF684326) : const Color(0xFF967336),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
