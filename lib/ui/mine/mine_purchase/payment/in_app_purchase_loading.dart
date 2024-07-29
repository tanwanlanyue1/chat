import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

class InAppPurchaseLoading extends StatelessWidget {
  static bool _visible = false;
  final RxString messageRx;

  const InAppPurchaseLoading._({Key? key, required this.messageRx})
      : super(key: key);

  ///显示充值对话框,如果充值成功返回充值内容，后续流程可根据需要调用RechargeSuccessDialog.show()弹出充值完成提示对话框
  static Future<void> show(RxString messageRx) async {
    if (_visible == true) {
      return;
    }
    _visible = true;
    await Get.dialog(InAppPurchaseLoading._(messageRx: messageRx),
            barrierDismissible: false)
        .whenComplete(() => _visible = false);
  }

  static void dismiss() {
    if (_visible) {
      _visible = false;
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoadingIndicator(),
                ObxValue<RxString>(
                  (rx) => Text(
                    rx.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs14m.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  messageRx,
                ),
              ],
            ),
          ),
        ));
  }
}
