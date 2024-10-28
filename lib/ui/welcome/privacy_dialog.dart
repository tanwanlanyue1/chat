import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/welcome/welcome_storage.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'package:guanjia/widgets/widgets.dart';

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
                  S.current.serviceAndPrivacy,
                  style: AppTextStyle.fs16m.copyWith(color: Colors.black),
                ),
                Padding(
                  padding: FEdgeInsets(all: 16.rpx),
                  child: RichText(
                    text: TextSpan(
                        style: AppTextStyle.fs14.copyWith(
                          height: 1.5,
                          color: AppColor.black3,
                        ),
                        children: [
                           TextSpan(
                              text: S.current.pleaseSureCarefullyReadFully),
                          TextSpan(
                            text: '《${S.current.serviceAgreement}》',
                            style: AppTextStyle.fs14.copyWith(
                              color: AppColor.primaryBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                WebPage.go(url: AppConfig.urlUserService);
                              },
                          ),
                          TextSpan(text: S.current.and),
                          TextSpan(
                            text: S.current.privacyPolicy,
                            style: AppTextStyle.fs14.copyWith(
                              color: AppColor.primaryBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                WebPage.go(url: AppConfig.urlPrivacyPolicy);
                              },
                          ),
                          TextSpan(
                              text: S.current.learnMore),
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
                          S.current.disagreeTemporarily,
                          style: AppTextStyle.fs16
                      ),
                    ),
                    CommonGradientButton(
                      height: 50.rpx,
                      width: 120.rpx,
                      text: S.current.agreeAndAccept,
                      onTap: () => Get.back(result: true),
                      textStyle: AppTextStyle.fs16.copyWith(color: Colors.white),
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
