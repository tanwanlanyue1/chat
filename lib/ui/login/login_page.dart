import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/ui/login/widgets/login_text_field.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/generated/l10n.dart';
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
            bottom: Get.mediaQuery.padding.bottom,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.rpx)
                        .copyWith(top: 28.rpx),
                    children: [
                      Text(
                        S.current.loginWelcome,
                        style: AppTextStyle.st.medium
                            .size(30.rpx)
                            .textColor(Colors.white),
                      ),
                      SizedBox(height: 50.rpx),
                      LoginTextField(
                        controller: controller.registerAccountController,
                        labelText: S.current.loginAccount,
                      ),
                      SizedBox(height: 16.rpx),
                      LoginTextField(
                        controller: controller.registerPasswordController,
                        labelText: S.current.loginPassword,
                        obscureText: true,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16.rpx, bottom: 30.rpx),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: controller.onTapToForgotPage,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            S.current.loginForgetPassword,
                            style: AppTextStyle.st.medium
                                .size(14.rpx)
                                .textColor(Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      CommonGradientButton(
                        onTap: () => controller.onLogin(1),
                        text: S.current.login,
                        height: 50.rpx,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: controller.onTapToRegisterPage,
                  child: Container(
                    padding: EdgeInsets.all(8.rpx),
                    alignment: Alignment.center,
                    child: Text(
                      S.current.loginRegister,
                      style: AppTextStyle.st.medium
                          .size(14.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
