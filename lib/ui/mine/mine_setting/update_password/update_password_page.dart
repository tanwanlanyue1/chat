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
  final controller = Get.find<UpdatePasswordController>();
  final state = Get.find<UpdatePasswordController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.isLogin.value ? S.current.changingPassword : S.current.changingPaymentPassword,
        ),
      ),
      backgroundColor: AppColor.grayF7,
      body: ListView(
        padding: EdgeInsets.only(top: 24.rpx),
        children: [
          _buildPhoneNumberTips(),
          _buildVerificationCodeField(),
          _buildVerificationMode(),
          Visibility(
            visible: state.isLogin.value,
            replacement: _buildPaymentPasswordField(),
            child: _buildNewPasswordField(),
          ),
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
      margin: EdgeInsets.only(bottom: 16.rpx,left: 6.rpx,right: 6.rpx),
      child: Text(
        state.isPhone.value ?
        '${S.current.phoneVerificationCode}${controller.phoneNumberInputController.text}${S.current.cellPhone}':
        S.current.emailVerificationCode+controller.phoneNumberInputController.text+S.current.cellEmail,
        style: TextStyle(
          fontSize: 12.rpx,
          color: AppColor.gray80,
        ),
      ),
    ));
  }

  //验证方式
  Widget _buildVerificationMode() {
    return GestureDetector(
      onTap: controller.verificationMode,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(bottom: 24.rpx,top: 11.rpx,right: 16.rpx),
        child: Visibility(
          visible: !state.type,
          child: RichText(
            text: TextSpan(
              text: "${S.current.notReceiveTheVerification}? ",
              style: TextStyle(
                fontSize: 10.rpx,
                color: AppColor.black666,
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
      ),
    );
  }

  //验证码输入框
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

  //新密码输入框
  Widget _buildNewPasswordField() {
    return Obx(() => SettingTextField(
      labelText: S.current.enterYourPIN,
      inputController: controller.newPasswordInputController,
      hintText: S.current.pleaseEnter620Characters,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LengthLimitingTextInputFormatter(16),
      ],
      obscureText: state.obscure.value,
      showPasswordVisible: true,
      callBack: (){
        state.obscure.value = !state.obscure.value;
      },
    ));
  }

  //支付输入密码
  Widget _buildPaymentPasswordField() {
    return SettingTextField(
      labelText: S.current.enterYourPIN,
      inputController: controller.newPasswordInputController,
      hintText: S.current.sixPaymentPassword,
      readOnly: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      onTapCall: controller.setPayPassword,
      obscureText: true,
    );
  }

  //确认密码输入框
  Widget _buildConfirmPasswordField() {
    return Obx(() => SettingTextField(
      labelText: S.current.pleaseConfirmThePassword,
      inputController: controller.confirmPasswordInputController,
      hintText: S.current.pleaseEnterYourConfirmationPassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LengthLimitingTextInputFormatter(16),
      ],
      obscureText: state.obscure.value,
      showPasswordVisible: state.isLogin.value,
      callBack: (){
        state.obscure.value = !state.obscure.value;
      },
      readOnly: !state.isLogin.value,
      onTapCall: ()=> !state.isLogin.value ? controller.setPayPassword(affirm: true) : null,
    ));
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return GestureDetector(
        onTap: state.isVisible.value ? (state.isLogin.value ? controller.submit : controller.submitPayment) : null,
        child: Container(
          height: 42.rpx,
          decoration: BoxDecoration(
              color: AppColor.gradientBegin
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
