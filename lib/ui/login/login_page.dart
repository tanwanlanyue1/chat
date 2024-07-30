import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
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
      // appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.yellow,
            ),
          ),
          Positioned.fill(
            child: AppImage.asset(
              "assets/login/default_bg.png",
              fit: BoxFit.fill,
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("data"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerWidget() {
    return GetBuilder<LoginController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.rpx)
            .copyWith(top: 20.rpx, bottom: 74.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "注册账号",
              style: AppTextStyle.st.size(16.rpx).textColor(AppColor.primary),
            ),
            SizedBox(height: 20.rpx),
            Container(
              height: 46.rpx,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx)),
              padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Row(
                      children: [
                        AppImage.asset("assets/images/login/login_user.png",
                            width: 24.rpx, height: 24.rpx),
                        SizedBox(width: 8.rpx),
                        Expanded(
                            child: TextField(
                                controller:
                                    controller.registerAccountController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                decoration: InputDecoration(
                                  hintText: "用户账号",
                                  hintStyle: TextStyle(
                                      color: const Color(0x4D8D310F),
                                      fontSize: 14.rpx),
                                  border: InputBorder.none,
                                  isDense: true,
                                )))
                      ],
                    ),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: !state.isRegisterAccountReady.value,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "不超过20字符",
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(const Color(0x4D8D310F)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20.rpx),
            Container(
              height: 46.rpx,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx)),
              padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
              child: Row(
                children: [
                  AppImage.asset("assets/images/login/login_password.png",
                      width: 24.rpx, height: 24.rpx),
                  SizedBox(width: 8.rpx),
                  Obx(() {
                    return Expanded(
                        child: TextField(
                            controller: controller.registerPasswordController,
                            obscureText: !state.isVisible.value,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            decoration: InputDecoration(
                              hintText: "请输入6-20位字符",
                              hintStyle: TextStyle(
                                  color: const Color(0x4D8D310F),
                                  fontSize: 14.rpx),
                              border: InputBorder.none,
                              isDense: true,
                            )));
                  }),
                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.changeVisible(),
                      child: AppImage.asset(
                          state.isVisible.value
                              ? "assets/images/login/login_visible.png"
                              : "assets/images/login/login_invisible.png",
                          width: 24.rpx,
                          height: 24.rpx),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20.rpx),
            Container(
              height: 46.rpx,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx)),
              padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
              child: Row(
                children: [
                  AppImage.asset("assets/images/login/login_password.png",
                      width: 24.rpx, height: 24.rpx),
                  SizedBox(width: 8.rpx),
                  Obx(() {
                    return Expanded(
                        child: TextField(
                            controller:
                                controller.registerConfirmPasswordController,
                            obscureText: !state.isVisible.value,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            decoration: InputDecoration(
                              hintText: "再次输入密码",
                              hintStyle: TextStyle(
                                  color: const Color(0x4D8D310F),
                                  fontSize: 14.rpx),
                              border: InputBorder.none,
                              isDense: true,
                            )));
                  }),
                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.changeVisible(),
                      child: AppImage.asset(
                          state.isVisible.value
                              ? "assets/images/login/login_visible.png"
                              : "assets/images/login/login_invisible.png",
                          width: 24.rpx,
                          height: 24.rpx),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 115.rpx),
            Center(
              child: Obx(() {
                return TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) {
                        return states.contains(MaterialState.disabled)
                            ? const Color(0x268D310F)
                            : const Color(0xFF8D310F);
                      }),
                      minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 42.rpx)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21.rpx),
                        ),
                      ),
                      overlayColor: MaterialStateColor.resolveWith((states) {
                        return Colors.transparent;
                      }),
                    ),
                    onPressed: state.isRegisterReady.value
                        ? () => controller.onLogin(type)
                        : null,
                    child: Text(
                      "注册",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.rpx,
                          fontWeight: FontWeight.w500),
                    ));
              }),
            ),
          ],
        ),
      );
    });
  }

  Container _contentContainer() {
    return Container(
      decoration: BoxDecoration(
        image: AppDecorations.backgroundImage(
            "assets/images/login/login_content_bg.png"),
      ),
      width: 335.rpx,
      height: 293.rpx,
      padding: EdgeInsets.only(left: 16.rpx, right: 16.rpx, top: 24.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isSmsLogin ? "验证码登录" : "密码登录",
              style: TextStyle(
                  color: const Color(0xff8D310F),
                  fontSize: 16.rpx,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 12.rpx),
          Container(
            height: 46.rpx,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx)),
            padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
            child: Row(
              children: [
                AppImage.asset("assets/images/login/login_account.png",
                    width: 24.rpx, height: 24.rpx),
                SizedBox(width: 8.rpx),
                Expanded(
                    child: TextField(
                        controller: isSmsLogin
                            ? controller.accountController
                            : controller.passwordAccountController,
                        keyboardType: isSmsLogin
                            ? TextInputType.number
                            : TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(isSmsLogin ? 11 : 20)
                        ],
                        decoration: InputDecoration(
                          hintText: isSmsLogin ? "请输入手机号码" : "请输入手机号码或账号",
                          hintStyle: TextStyle(
                              color: const Color(0x4D8D310F), fontSize: 14.rpx),
                          border: InputBorder.none,
                          isDense: true,
                        )))
              ],
            ),
          ),
          SizedBox(height: 12.rpx),
          Container(
            height: 46.rpx,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx)),
            padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
            child: Row(
              children: [
                AppImage.asset(
                    isSmsLogin
                        ? "assets/images/login/login_sms.png"
                        : "assets/images/login/login_password.png",
                    width: 24.rpx,
                    height: 24.rpx),
                SizedBox(width: 8.rpx),
                Obx(() {
                  return Expanded(
                      child: TextField(
                          controller: isSmsLogin
                              ? controller.smsCodeController
                              : controller.passwordCodeController,
                          keyboardType: isSmsLogin
                              ? TextInputType.number
                              : TextInputType.text,
                          obscureText: !state.isVisible.value && !isSmsLogin,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          decoration: InputDecoration(
                            hintText: isSmsLogin ? "请输入验证码" : "请输入密码",
                            hintStyle: TextStyle(
                                color: const Color(0x4D8D310F),
                                fontSize: 14.rpx),
                            border: InputBorder.none,
                            isDense: true,
                          )));
                }),
                isSmsLogin
                    ? Obx(() {
                        return GestureDetector(
                          onTap: () => state.isCountingDown.value
                              ? null
                              : controller.onFetchSms(),
                          child: Text(
                            state.smsButtonText.value,
                            style: TextStyle(
                                color: const Color(0xFF8D310F),
                                fontSize: 14.rpx),
                          ),
                        );
                      })
                    : Obx(() {
                        return GestureDetector(
                          onTap: () => controller.changeVisible(),
                          child: AppImage.asset(
                              state.isVisible.value
                                  ? "assets/images/login/login_visible.png"
                                  : "assets/images/login/login_invisible.png",
                              width: 24.rpx,
                              height: 24.rpx),
                        );
                      }),
              ],
            ),
          ),
          SizedBox(height: 8.rpx),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: isSmsLogin
                      ? null
                      : () => controller.onTapToUpdatePasswordPage(),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    isSmsLogin ? "未注册手机验证后自动创建账号" : "忘记密码？",
                    style: TextStyle(
                        color: const Color(0xFF999999), fontSize: 12.rpx),
                  ),
                ),
                Visibility(
                    visible: !isSmsLogin,
                    child: GestureDetector(
                      onTap: () => controller.onTapToAccountRegisterPage(),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        "注册账号",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 12.rpx,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 30.rpx),
          Center(
            child: Obx(() {
              return TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                      return states.contains(MaterialState.disabled)
                          ? const Color(0x268D310F)
                          : const Color(0xFF8D310F);
                    }),
                    minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 42.rpx)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21.rpx),
                      ),
                    ),
                    overlayColor: MaterialStateColor.resolveWith((states) {
                      return Colors.transparent;
                    }),
                  ),
                  onPressed: (state.isSmsReady.value && isSmsLogin) ||
                          state.isPasswordReady.value && !isSmsLogin
                      ? () => controller.onLogin(type)
                      : null,
                  child: Text(
                    "登录",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.rpx,
                        fontWeight: FontWeight.w500),
                  ));
            }),
          )
        ],
      ),
    );
  }

  Widget _otherLoginColumn() {
    return Obx(() {
      final hasWXLogin = state.hasWXLogin.value;
      final hasOneKeyLogin = state.hasOneKeyLogin.value;
      final hasAppleLogin = GetPlatform.isIOS;
      final hasPasswordLogin = isSmsLogin;

      if (!hasWXLogin &&
          !hasOneKeyLogin &&
          !hasAppleLogin &&
          !hasPasswordLogin) {
        return const SizedBox();
      }

      return Column(
        children: [
          AppImage.asset("assets/images/login/login_other_label.png",
              width: 212.rpx, height: 20.rpx),
          SizedBox(height: 30.rpx),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (hasWXLogin)
                GestureDetector(
                  child: AppImage.asset(
                      "assets/images/login/login_other_wx.png",
                      width: 46.rpx,
                      height: 46.rpx),
                ),
              if (hasOneKeyLogin)
                GestureDetector(
                  child: AppImage.asset(
                      "assets/images/login/login_other_onekey.png",
                      width: 46.rpx,
                      height: 46.rpx),
                ),
              if (hasAppleLogin)
                GestureDetector(
                  child: AppImage.asset(
                      "assets/images/login/login_other_apple.png",
                      width: 46.rpx,
                      height: 46.rpx),
                ),
              if (hasPasswordLogin)
                GestureDetector(
                  onTap: () => controller.onTapToPasswordLoginPage(),
                  child: AppImage.asset(
                      "assets/images/login/login_other_password.png",
                      width: 46.rpx,
                      height: 46.rpx),
                ),
            ],
          )
        ],
      );
    });
  }

  Container _privacyContainer() {
    final textStyle = AppTextStyle.st.size(12.rpx).textColor(AppColor.gray5);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.rpx),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.rpx),
              child: Obx(() {
                return GestureDetector(
                  onTap: () => controller.changeSelectPrivacy(),
                  child: AppImage.asset(
                      state.isSelectPrivacy.value
                          ? "assets/images/login/login_choose_select.png"
                          : "assets/images/login/login_choose_normal.png",
                      width: 16.rpx,
                      height: 16.rpx),
                );
              }),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
                child: Text.rich(
              TextSpan(text: "登录代表您已阅读并同意", children: [
                TextSpan(
                    recognizer: controller.protocolProtocolRecognizer
                      ..onTap = () => controller.onTapToProtocol(),
                    text: "用户协议",
                    style: textStyle),
                const TextSpan(text: "、"),
                TextSpan(
                    recognizer: controller.privacyProtocolRecognizer
                      ..onTap = () => controller.onTapToPrivacy(),
                    text: "隐私政策",
                    style: textStyle),
                const TextSpan(text: "并授权使用您的账号信息（如头像、昵称、地址）以便您统一管理"),
              ]),
              style:
                  TextStyle(color: const Color(0x808D310F), fontSize: 12.rpx),
            ))
          ],
        ));
  }
}
