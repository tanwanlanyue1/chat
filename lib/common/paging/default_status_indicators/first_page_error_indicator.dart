import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class FirstPageErrorIndicator extends StatelessWidget {
  const FirstPageErrorIndicator({
    required this.title,
    this.message,
    this.onTryAgain,
    super.key,
  });

  final String title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage.asset(
              'assets/images/common/default_error.png',
              width: 100.rpx,
              height: 80.rpx,
              fit: BoxFit.cover,
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
      ),
    );
  }
}