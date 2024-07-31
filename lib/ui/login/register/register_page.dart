import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/login/widgets/login_text_field.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/generated/l10n.dart';

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
                        S.current.register,
                        style: AppTextStyle.st.medium
                            .size(30.rpx)
                            .textColor(Colors.white),
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.userNameController,
                        hintText: S.current.registerAccountHint,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.passwordController,
                        hintText: S.current.registerPasswordHint,
                        obscureText: true,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.passwordAgainController,
                        hintText: S.current.registerPasswordAgainHint,
                        obscureText: true,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.phoneController,
                        hintText: S.current.registerPhoneHint,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: textFieldPadding),
                      LoginTextField(
                        controller: controller.emailController,
                        hintText: S.current.registerEmailHint,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16.rpx, bottom: 30.rpx),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: null,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            "${S.current.registerAgreement} ${S.current.webUser}",
                            style: AppTextStyle.st.medium
                                .size(14.rpx)
                                .textColor(Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      CommonGradientButton(
                        onTap: controller.onTapRegister,
                        text: S.current.registerSpace,
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
                      S.current.registerLogin,
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
