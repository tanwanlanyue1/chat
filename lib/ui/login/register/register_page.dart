import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/login/widgets/login_text_field.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import 'register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final controller = Get.put(RegisterController());
  final state = Get.find<RegisterController>().state;

  @override
  Widget build(BuildContext context) {
    final textFieldPadding = 16.rpx;

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
                        .copyWith(top: 68.rpx),
                    children: [
                      Text(
                        "注册",
                        style: AppTextStyle.st.medium
                            .size(30.rpx)
                            .textColor(Colors.white),
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.userNameController,
                        hintText: "请输入用户名",
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.passwordController,
                        hintText: "请设置6-20位登录密码",
                        obscureText: true,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.passwordAgainController,
                        hintText: "请再次确认登陆密码",
                        obscureText: true,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.phoneController,
                        hintText: "+1 194-351-2685（手机号码选填）",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.emailController,
                        hintText: "请输入您的邮箱（选填）",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16.rpx, bottom: 30.rpx),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: null,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            "点击注册默认同意 用户协议",
                            style: AppTextStyle.st.medium
                                .size(14.rpx)
                                .textColor(Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      CommonGradientButton(
                        onTap: controller.onTapRegister,
                        text: "注 册",
                        height: 50.rpx,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    padding: EdgeInsets.all(8.rpx),
                    alignment: Alignment.center,
                    child: Text(
                      "已有账号？去登录",
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
