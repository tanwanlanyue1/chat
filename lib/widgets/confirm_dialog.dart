import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';

///确认对话框
class ConfirmDialog extends StatelessWidget {
  final Widget message;
  final Widget? cancelButtonText;
  final Widget? okButtonText;
  static var _isVisible = false;

  const ConfirmDialog._({
    super.key,
    required this.message,
    this.cancelButtonText,
    this.okButtonText,
  });

  static bool get isVisible => _isVisible;

  ///显示确认对话框
  static Future<bool> show({
    required Widget message,
    Widget? cancelButtonText,
    Widget? okButtonText,
  }) async {
    if (!_isVisible) {
      _isVisible = true;
      final result = await Get.dialog<bool>(ConfirmDialog._(
        message: message,
        cancelButtonText: cancelButtonText ?? const Text('取消'),
        okButtonText: okButtonText,
      )).whenComplete(() => _isVisible = false);
      return result == true;
    }
    return false;
  }

  ///显示消息对话框，没有取消按钮
  static Future<bool> alert({
    required Widget message,
    Widget? okButtonText,
  }) async {
    if (!_isVisible) {
      _isVisible = true;
      final result = await Get.dialog<bool>(ConfirmDialog._(
        message: message,
        okButtonText: okButtonText,
      )).whenComplete(() => _isVisible = false);
      return result == true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: SizedBox(
          width: 311.rpx,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: Get.back,
                  icon: AppImage.asset(
                    'assets/images/common/close.png',
                    width: 24.rpx,
                    height: 24.rpx,
                  ),
                ),
              ),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx),
                child: DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: AppTextStyle.fs16b.copyWith(
                    color: AppColor.blackBlue,
                    height: 1.5,
                  ),
                  child: message,
                ),
              ),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
      child: Row(
        mainAxisAlignment: cancelButtonText != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          if (cancelButtonText != null)
            Button(
              width: 120.rpx,
              height: 50.rpx,
              backgroundColor: AppColor.black999,
              child: DefaultTextStyle(
                style: AppTextStyle.fs16m,
                child: cancelButtonText ?? const Text('取消'),
              ),
              onPressed: () {
                Get.back(result: false);
              },
            ),
          okButtonText ?? CommonGradientButton(
            width: 120.rpx,
            height: 50.rpx,
            text: '确定',
            textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white),
            onTap: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
    );
  }
}
