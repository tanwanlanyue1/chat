import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final int type; // 0：验证码登录，1：密码登录，2：注册，
  LoginPage({
    super.key,
    this.type = 0, // 默认为验证码登录
  })  : isSmsLogin = type == 0,
        isRegisterLogin = type == 2;

  final bool isRegisterLogin;
  final bool isSmsLogin;

  final controller = Get.put(LoginController());
  final state = Get.find<LoginController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AppImage.asset(
              "assets/images/login/default_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: kBottomNavigationBarHeight + Get.mediaQuery.padding.top,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "您好， \n欢迎回来！",
                      style: AppTextStyle.st.medium
                          .size(30.rpx)
                          .textColor(Colors.white),
                    ),
                    SizedBox(height: 50.rpx),
                    Container(
                      height: 54.rpx,
                      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        // controller: controller.registerPasswordController,
                        decoration: InputDecoration(
                          labelText: "账号",
                          labelStyle: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(const Color(0xff929db2)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.rpx),
                    Container(
                      height: 54.rpx,
                      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        // controller: controller.registerPasswordController,
                        decoration: InputDecoration(
                          labelText: "密码",
                          labelStyle: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(const Color(0xff929db2)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.rpx, bottom: 30.rpx),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: controller.onTapToUpdatePasswordPage,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          "忘记密码？",
                          style: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    CommonGradientButton(
                      onTap: () => controller.onLogin(1),
                      text: "登录",
                      height: 50.rpx,
                    ),
                    SizedBox(height: 252.rpx),
                    GestureDetector(
                      onTap: controller.onTapToAccountRegisterPage,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "还没有账号？马上注册",
                          style: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
