import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
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
        borderRadius: BorderRadius.circular(12.rpx),
        child: Container(
          width: 295.rpx,
          padding: FEdgeInsets(horizontal: 24.rpx, vertical: 26.rpx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: FEdgeInsets(bottom: 26.rpx),
                child: DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: AppTextStyle.fs20m.copyWith(
                    color: AppColor.gray5,
                    height: 30 / 20,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cancelButtonText != null)
          Button.stadium(
            width: 110.rpx,
            height: 36.rpx,
            margin: FEdgeInsets(right: 24.rpx),
            backgroundColor: AppColor.gray9.withAlpha(80),
            child: DefaultTextStyle(
              style: AppTextStyle.fs16m,
              child: cancelButtonText ?? const Text('取消'),
            ),
            onPressed: () {
              Get.back(result: false);
            },
          ),
        Button.stadium(
          width: 110.rpx,
          height: 36.rpx,
          backgroundColor: AppColor.primaryBlue,
          child: DefaultTextStyle(
            style: AppTextStyle.fs16m,
            child: okButtonText ?? const Text('确定'),
          ),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ],
    );
  }
}
