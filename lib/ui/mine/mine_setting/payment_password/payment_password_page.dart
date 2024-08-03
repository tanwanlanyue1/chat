import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/setting_text_field.dart';

import 'payment_password_controller.dart';

//设置支付密码
class PaymentPasswordPage extends StatelessWidget {
  PaymentPasswordPage({Key? key}) : super(key: key);

  final controller = Get.put(PaymentPasswordController());
  final state = Get.find<PaymentPasswordController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.setPaymentPassword,
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 24.rpx),
          _buildNewPasswordField(),
          SizedBox(height: 1.rpx),
          _buildConfirmPasswordField(),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  //输入密码
  Widget _buildNewPasswordField() {
    return SettingTextField(
      labelText: S.current.enterYourPIN,
      inputController: controller.newPasswordInputController,
      hintText: S.current.sixPaymentPassword,
      readOnly: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LengthLimitingTextInputFormatter(16),
      ],
      obscureText: true,
      onTapCall: controller.setPayPassword,
    );
  }

  //确认密码
  Widget _buildConfirmPasswordField() {
    return SettingTextField(
      labelText: S.current.pleaseConfirmThePassword,
      inputController: controller.confirmPasswordInputController,
      hintText: S.current.confirmPayment,
      readOnly: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      obscureText: true,
      onTapCall: (){
        controller.setPayPassword(affirm: true);
      },
    );
  }

  //提交按钮
  Widget _buildSubmitButton() {
    return Obx(() {
      return GestureDetector(
        onTap: state.isVisible.value ? controller.submit : null,
        child: Container(
          height: 50.rpx,
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
