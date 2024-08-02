import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

//征友约会-弹窗
class DraftDialog extends StatelessWidget {
  const DraftDialog({super.key});

  //进阶弹窗
  static Future<bool?> show() {
    return Get.dialog(
      DraftDialog(),
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
