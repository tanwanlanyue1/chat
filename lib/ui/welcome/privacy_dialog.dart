import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/welcome/welcome_storage.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'privacy.dart';

///隐私协议对话框
class PrivacyDialog extends StatelessWidget {
  static var _visible = false;

  const PrivacyDialog._({super.key});

  static void show({VoidCallback? onCancel, VoidCallback? onAgree}) async {
    if (_visible) {
      return;
    }
    _visible = true;
    final result = await Get.dialog<bool>(
      const PrivacyDialog._(),
      barrierDismissible: false,
    ).whenComplete(() => _visible = false);

    if(result == true){
      WelcomeStorage.savePrivacyVisible(false);
      onAgree?.call();
    }else{
      onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: FEdgeInsets(horizontal: 32.rpx),
            padding: FEdgeInsets(vertical: 24.rpx),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '服务协议和隐私政策',
                  style: AppTextStyle.fs16b.copyWith(color: Colors.black),
                ),
                Padding(
                  padding: FEdgeInsets(all: 16.rpx),
                  child: RichText(
                    text: TextSpan(
                        style: AppTextStyle.fs14m.copyWith(
                          height: 1.5,
                          color: AppColor.black3,
                        ),
                        children: [
                          const TextSpan(
                              text:
                                  '    请您务必谨慎阅读、充分理解“服务协议”和“隐私政策”条款，包括但不限于为了更好的向您提供服务，我们需要手机你的设备标识、操作日志等信息用于分析、优化原有性能。您可阅读'),
                          TextSpan(
                            text: '《服务协议》',
                            style: AppTextStyle.fs14m.copyWith(
                              color: AppColor.primaryBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                WebPage.go(url: AppConfig.urlUserService);
                              },
                          ),
                          const TextSpan(text: '和'),
                          TextSpan(
                            text: '《隐私政策》',
                            style: AppTextStyle.fs14m.copyWith(
                              color: AppColor.primaryBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                WebPage.go(url: AppConfig.urlPrivacyPolicy);
                              },
                          ),
                          const TextSpan(
                              text: '了解详细信息。\n    如同意，请点击下面按钮开始接受我们的服务。'),
                        ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Button(
                      onPressed: () => Get.back(result: false),
                      height: 50.rpx,
                      width: 120.rpx,
                      backgroundColor: AppColor.gray9,
                      child: Text(
                          '暂不同意',
                          style: AppTextStyle.fs16m
                      ),
                    ),
                    CommonGradientButton(
                      height: 50.rpx,
                      width: 120.rpx,
                      text: '同意并接受',
                      onTap: () => Get.back(result: true),
                      textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
