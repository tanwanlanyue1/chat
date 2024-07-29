import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/widgets/login_verification_code_button.dart';
import 'package:guanjia/ui/mine/widgets/setting_text_field.dart';

import 'binding_controller.dart';

class BindingPage extends StatelessWidget {
  BindingPage({Key? key}) : super(key: key);

  final controller = Get.put(BindingController());
  final state = Get.find<BindingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: Text(
          "绑定手机",
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx, top: 16.rpx),
        children: [
          _buildPhoneNumberTips(),
          _buildPhoneField(),
          _buildVerificationCodeField(),
          _buildSubmitButton(),
        ]
            .separated(
              SizedBox(
                height: 10.rpx,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPhoneNumberTips() {
    return Padding(
      padding: EdgeInsets.only(left: 12.rpx),
      child: Text(
        '使用以下安全验证手机号码获取验证码',
        style: TextStyle(
          fontSize: 14.rpx,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return SettingTextField(
      inputController: controller.phoneNumberInputController,
      labelText: '手机号',
      hintText: '请输入手机号码',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(11),
      ],
    );
  }

  Widget _buildVerificationCodeField() {
    return SettingTextField(
      inputController: controller.verificationInputController,
      labelText: '验证码',
      hintText: '输入验证码',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ],
      suffixIcon: LoginVerificationCodeButton(
        onFetch: controller.fetchSms,
      ),
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
              borderRadius: BorderRadius.circular(23.rpx)),
          margin: EdgeInsets.symmetric(horizontal: 8.rpx, vertical: 40.rpx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "确定",
                style: TextStyle(color: Colors.white, fontSize: 16.rpx),
              )
            ],
          ),
        ),
      );
    });
  }
}
