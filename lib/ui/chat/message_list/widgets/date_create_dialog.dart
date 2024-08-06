import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///发起约会对话框
class DateCreateDialog extends StatelessWidget {
  const DateCreateDialog._({super.key});

  //进阶弹窗
  static Future<bool?> show() {
    return Get.dialog(
      DateCreateDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: SizedBox(
          width: 311.rpx,
        ),
      ),
    );
  }
}
