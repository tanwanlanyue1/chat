import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
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
        const TextSpan(text: '已阅读并同意'),
        TextSpan(
          style: highlightTextStyle,
          text: '用户协议、',
          recognizer: TapGestureRecognizer()..onTap = () {
            dismiss();
            WebPage.go(url: AppConfig.urlUserService, title: '用户协议');
          },
        ),
        TextSpan(
          style: highlightTextStyle,
          text: '隐私政策',
          recognizer: TapGestureRecognizer()..onTap = () {
            dismiss();
            WebPage.go(url: AppConfig.urlPrivacyPolicy, title: '隐私政策');
          },
        ),
        const TextSpan(text: '并授权使用您的账号信息（如头像、昵称、地址）以便您统一管理'),
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
          child: Text('不同意', style: TextStyle(fontSize: 16.rpx)),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        Button.stadium(
          width: 110.rpx,
          height: 36.rpx,
          margin: FEdgeInsets(left: 24.rpx),
          backgroundColor: AppColor.primary,
          child: Text('同意', style: TextStyle(fontSize: 16.rpx)),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ],
    );
  }

}
