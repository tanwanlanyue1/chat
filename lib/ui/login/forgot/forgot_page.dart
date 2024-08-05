import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/ui/login/widgets/login_text_field.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'forgot_controller.dart';

class ForgotPage extends StatelessWidget {
  final bool isNext; // 忘记密码或者重置密码界面
  ForgotPage({
    super.key,
    this.isNext = false, // 默认为忘记密码
  });

  final controller = Get.put(ForgotController());
  final state = Get.find<ForgotController>().state;

  final double _textFieldPadding = 16.rpx;

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
            top: kNavigationBarHeight + Get.mediaQuery.padding.top,
            bottom: Get.mediaQuery.padding.bottom,
            left: 0,
            right: 0,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.rpx)
                  .copyWith(top: 28.rpx),
              children: isNext ? _resetWidget() : _forgotWidget(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _forgotWidget() {
    return [
      Text(
        S.current.forgotTitle,
        style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 20.rpx),
      Text(
        S.current.forgotTitleTip,
        style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 50.rpx),
      LoginTextField(
        controller: controller.emailController,
        labelText: S.current.forgotEmailHint,
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: 30.rpx),
      CommonGradientButton(
        onTap: controller.onTapToNext,
        text: S.current.forgotSend,
        height: 50.rpx,
      ),
    ];
  }

  List<Widget> _resetWidget() {
    return [
      Text(
        S.current.forgotNextTitle,
        style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 20.rpx),
      Text(
        S.current.forgotNextTitleTip,
        style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 50.rpx),
      LoginTextField(
        controller: controller.emailController,
        hintText: S.current.forgotCodeHint,
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: _textFieldPadding),
      LoginTextField(
        controller: controller.passwordController,
        hintText: S.current.forgotPasswordHint,
        obscureText: true,
      ),
      SizedBox(height: _textFieldPadding),
      LoginTextField(
        controller: controller.passwordAgainController,
        hintText: S.current.forgotPasswordAgainHint,
        obscureText: true,
      ),
      SizedBox(height: 30.rpx),
      CommonGradientButton(
        onTap: null,
        text: S.current.forgotResetPassword,
        height: 50.rpx,
      ),
    ];
  }
}
