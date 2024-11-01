import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/config/dev_server_switch.dart';
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/ui/login/widgets/login_text_field.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  ///是否是安装应用后首次打开APP
  final bool isFirstOpenApp;
  const LoginPage({
    super.key,
    this.isFirstOpenApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(isFirstOpenApp),
      builder: (controller){
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              if (!AppInfo.isRelease)
                DevServerSwitch(
                  additionServers: [
                    //颜鹏
                    Server(
                      api: Uri.parse('http://192.168.2.18:20000'),
                      ws: Uri.parse(''),
                    ),
                    //杨文
                    Server(
                      api: Uri.parse('http://192.168.2.17:20000'),
                      ws: Uri.parse(''),
                    ),
                    //测试服
                    Server(
                      api: Uri.parse('http://192.168.2.79:20000'),
                      ws: Uri.parse(''),
                    ),
                  ],
                ),
            ],
            systemOverlayStyle: SystemUI.lightStyle.copyWith(
              systemNavigationBarColor: Colors.black,
            ),
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
                bottom: Get.mediaQuery.padding.bottom + 20.rpx,
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
                            controller: controller.accountController,
                            labelText: S.current.userName,
                          ),
                          SizedBox(height: 16.rpx),
                          LoginTextField(
                            controller: controller.passwordController,
                            labelText: S.current.loginPassword,
                            showPasswordVisible: true,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16.rpx, bottom: 30.rpx),
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: controller.onTapToForgotPage,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                S.current.loginForgetPassword,
                                style: AppTextStyle.fs14m.copyWith(color: Colors.white.withOpacity(0.5)),
                              ),
                            ),
                          ),
                          CommonGradientButton(
                            onTap: () => controller.onTapLogin(),
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
      },
    );
  }
}
