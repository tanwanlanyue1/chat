import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class NoItemsFoundIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final EdgeInsets padding;
  const NoItemsFoundIndicator({
    required this.title,
    this.message,
    this.onTryAgain,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(
      vertical: 32,
      horizontal: 16,
    ),
    super.key,
  });

  final String title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Container(
      alignment: Alignment.center,
      color: backgroundColor,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage.asset(
            'assets/images/common/default_empty.png',
            width: 176.rpx,
            height: 140.rpx,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.rpx),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.rpx,
                color: AppColor.gray9,
              ),
            ),
          ),
          if (message != null)
            const SizedBox(
              height: 16,
            ),
          if (message != null)
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          if (onTryAgain != null)
            const SizedBox(
              height: 48,
            ),
          if (onTryAgain != null)
            Button.stadium(
              height: 48.rpx,
              margin: FEdgeInsets(horizontal: 24.rpx),
              onPressed: onTryAgain,
              child: const Text(
                '点击重试',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
