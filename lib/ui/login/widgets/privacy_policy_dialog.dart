import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'package:guanjia/widgets/widgets.dart';

///隐私政策确认对话框
class PrivacyPolicyDialog extends StatelessWidget {
  static var _visible = false;
  const PrivacyPolicyDialog._({Key? key}) : super(key: key);

  static Future<bool?> show() async{
    if(!_visible){
      _visible = true;
      return Get.dialog<bool>(const PrivacyPolicyDialog._()).whenComplete(() => _visible = false);
    }
    return false;
  }

  static void dismiss([bool result = false]) {
    if(_visible){
      _visible = false;
      Get.back(result: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 295.rpx,
        padding: FEdgeInsets(horizontal: 22.rpx, vertical: 28.rpx),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.rpx),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildText(), Spacing.h24, _buildButtons()],
        ),
      ),
    );
  }

  Widget _buildText() {
    var highlightTextStyle = const TextStyle(color: AppColor.primary);
    return Text.rich(
      style: TextStyle(
        fontSize: 15.rpx,
        height: 21 / 15,
        color: Colors.black,
      ),
      TextSpan(children: [
        TextSpan(text: S.current.readAndAgree),
        TextSpan(
          style: highlightTextStyle,
          text: '${S.current.webUser}、',
          recognizer: TapGestureRecognizer()..onTap = () {
            dismiss();
            WebPage.go(url: AppConfig.urlUserService, title: S.current.webUser);
          },
        ),
        TextSpan(
          style: highlightTextStyle,
          text: S.current.privacyPolicyTitle,
          recognizer: TapGestureRecognizer()..onTap = () {
            dismiss();
            WebPage.go(url: AppConfig.urlPrivacyPolicy, title: S.current.privacyPolicyTitle);
          },
        ),
        TextSpan(text: S.current.andAuthorizeUseNickname),
      ]),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Button.stadium(
          width: 110.rpx,
          height: 36.rpx,
          backgroundColor: AppColor.gray9.withAlpha(80),
          child: Text(S.current.noConsent, style: TextStyle(fontSize: 16.rpx)),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        Button.stadium(
          width: 110.rpx,
          height: 36.rpx,
          margin: FEdgeInsets(left: 24.rpx),
          backgroundColor: AppColor.primary,
          child: Text(S.current.consent, style: TextStyle(fontSize: 16.rpx)),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ],
    );
  }

}
