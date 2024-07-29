import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'privacy.dart';

///隐私协议对话框
class PrivacyDialog extends StatelessWidget {
  static var _visible = false;

  const PrivacyDialog._({super.key});

  static void show() {
    if (_visible) {
      return;
    }
    _visible = true;
    Get.dialog(
      const PrivacyDialog._(),
      barrierDismissible: false,
    );
  }

  final String _data =
      '''境修APP十分重视用户权利及隐私政策并严格按照相关法律法规的要求，对《境修用户服务协议》和《隐私政策》进行了更新,特向您说明如下：\n
1.为向您提供更优质的服务，我们会收集、使用必要的信息，并会采取业界先进的安全措施保护您的信息安全；
2.基于您的明示授权，我们可能会获取您的通知、相机、相册/存储、网络、麦克风等可能获取个人信息的设备权限。我们将使用第三方产品（个推、QQ、微信、阿里云号码认证）来实现部分服务以及功能，为此相关第三方有可能需要收集必要的个人信息。（以保障您的账号与交易安全），且您有权拒绝或取消授权；
3.您可灵活设置境修账号的功能内容和互动权限，您可在《隐私政策》中了解到权限的详细应用说明；
4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息；
5.您可以查询、更正、删除您的个人信息，我们也提供账户注销的渠道。\n
请您仔细阅读并充分理解相关条款，其中重点条款已为您黑体加粗标识，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《境修用户服务协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。''';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: Get.height * 0.6,
            width: Get.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  height: 45.rpx,
                  alignment: Alignment.center,
                  child: Text(
                    '温馨提示',
                    style: TextStyle(
                        fontSize: 16.rpx, fontWeight: FontWeight.bold),
                  ),
                ),
                // Divider(
                //   height: 1.h,
                // ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.rpx, bottom: 8.rpx, left: 16.rpx, right: 16.rpx),
                  child: SingleChildScrollView(
                    child: PrivacyView(
                      data: _data,
                      keys: const ['《境修用户服务协议》', '《隐私政策》'],
                      keyStyle: const TextStyle(color: AppColor.primary),
                      onTapCallback: (String key) {
                        if (key == '《境修用户服务协议》') {
                          WebPage.go(
                              url: AppConfig.urlUserService, title: '服务协议');
                        } else if (key == '《隐私政策》') {
                          WebPage.go(
                              url: AppConfig.urlPrivacyPolicy, title: '隐私政策');
                        }
                      },
                    ),
                  ),
                )),
                const Divider(height: 0),
                SizedBox(
                  height: 45.rpx,
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            alignment: Alignment.center,
                            child: const Text('不同意')),
                        onTap: () {
                          exit(0);
                        },
                      )),
                      const VerticalDivider(width: 0),
                      Expanded(
                          child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.rpx)),
                            ),
                            child: const Text(
                              '同意',
                              style: TextStyle(color: Colors.white),
                            )),
                        onTap: () {
                          Loading.show();
                          Global.agreePrivacyPolicy()
                              .whenComplete(Loading.dismiss);
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
