import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/login_verification_code_button.dart';
import 'package:guanjia/ui/mine/widgets/setting_text_field.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'update_password_controller.dart';

///修改登录密码/修改支付密码
class UpdatePasswordPage extends StatelessWidget {
  final controller = Get.put(UpdatePasswordController());
  final state = Get.find<UpdatePasswordController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.isLogin.value ? S.current.changingPassword : S.current.changingPaymentPassword,
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx, top: 24.rpx),
        children: [
          _buildPhoneNumberTips(),
          _buildVerificationCodeField(),
          _buildVerificationMode(),
          _buildNewPasswordField(),
          _buildConfirmPasswordField(),
          _buildSubmitButton(),
        ].separated(SizedBox(
              height: 1.rpx,
            ))
            .toList(),
      ),
    );
  }

  Widget _buildPhoneNumberTips() {
    return Obx(() => Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 15.rpx),
      child: Text(
        state.isPhone.value ?
        '${S.current.phoneVerificationCode}138****8888${S.current.cellPhone}':
        '${S.current.emailVerificationCode}1726****45.com${S.current.cellEmail}',
        style: TextStyle(
          fontSize: 12.rpx,
          color: AppColor.gray30,
        ),
      ),
    ));
  }

  //验证方式
  Widget _buildVerificationMode() {
    return GestureDetector(
      onTap: (){
        state.isPhone.value = !state.isPhone.value;
      },
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(bottom: 24.rpx,top: 11.rpx),
        child: RichText(
          text: TextSpan(
            text: "${S.current.notReceiveTheVerification}? ",
            style: TextStyle(
              fontSize: 12.rpx,
              color: AppColor.gray30,
            ),
            children: [
              TextSpan(
                text: S.current.changeVerificationMethod,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCodeField() {
    return Obx(() => SettingTextField(
      inputController: controller.verificationInputController,
      labelText: state.isPhone.value ?
      S.current.cellPhoneVerificationCode:S.current.cellEmailVerificationCode,
      hintText: S.current.pleaseEnterTheVerificationCode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ],
      suffixIcon: LoginVerificationCodeButton(
        onFetch: controller.fetchSms,
      ),
    ));
  }

  Widget _buildNewPasswordField() {
    return SettingTextField(
      labelText: S.current.enterYourPIN,
      inputController: controller.newPasswordInputController,
      hintText: S.current.pleaseEnter620Characters,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LengthLimitingTextInputFormatter(16),
      ],
      obscureText: true,
    );
  }

  Widget _buildConfirmPasswordField() {
    return SettingTextField(
      labelText: S.current.pleaseConfirmThePassword,
      inputController: controller.confirmPasswordInputController,
      hintText: S.current.pleaseEnterYourConfirmationPassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LengthLimitingTextInputFormatter(16),
      ],
      obscureText: true,
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return GestureDetector(
        onTap: state.isVisible.value ? controller.submit : null,
        child: Container(
          height: 42.rpx,
          decoration: BoxDecoration(
              color: AppColor.primary
                  .withOpacity(state.isVisible.value ? 1 : 0.15),
              borderRadius: BorderRadius.circular(8.rpx)),
          margin: EdgeInsets.symmetric(horizontal: 38.rpx, vertical: 40.rpx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.current.confirm,
                style: TextStyle(color: Colors.white, fontSize: 16.rpx),
              )
            ],
          ),
        ),
      );
    });
  }
}
