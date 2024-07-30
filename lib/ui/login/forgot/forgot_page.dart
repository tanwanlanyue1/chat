import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
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
            top: kBottomNavigationBarHeight + Get.mediaQuery.padding.top,
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
        "忘记密码？",
        style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 20.rpx),
      Text(
        "请在下面输入您的电子邮件已接收密码重置邮件？",
        style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 50.rpx),
      LoginTextField(
        controller: controller.emailController,
        labelText: "邮箱地址",
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: 30.rpx),
      CommonGradientButton(
        onTap: controller.onTapToNext,
        text: "发 送",
        height: 50.rpx,
      ),
    ];
  }

  List<Widget> _resetWidget() {
    return [
      Text(
        "重置密码",
        style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 20.rpx),
      Text(
        "重置代码发送到您的电子邮件。请输入代码并创建新密码",
        style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
      ),
      SizedBox(height: 50.rpx),
      LoginTextField(
        controller: controller.emailController,
        hintText: "重置代码",
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: _textFieldPadding),
      LoginTextField(
        controller: controller.passwordController,
        hintText: "新的密码",
        obscureText: true,
      ),
      SizedBox(height: _textFieldPadding),
      LoginTextField(
        controller: controller.passwordAgainController,
        hintText: "确认密码",
        obscureText: true,
      ),
      SizedBox(height: 30.rpx),
      CommonGradientButton(
        onTap: null,
        text: "更改密码",
        height: 50.rpx,
      ),
    ];
  }
}
