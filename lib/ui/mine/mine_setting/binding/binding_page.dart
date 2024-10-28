import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recaptcha_v2_compat/recaptcha_v2.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_localization.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/login_verification_code_button.dart';
import 'package:guanjia/ui/mine/widgets/setting_text_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'binding_controller.dart';

class BindingPage extends StatelessWidget {
  BindingPage({Key? key}) : super(key: key);

  final controller = Get.find<BindingController>();
  final state = Get.find<BindingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              state.isPhone.value ? S.current.bindPhone : S.current.bindEmail,
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: 18.rpx,
              ),
            )),
      ),
      backgroundColor: AppColor.grayF7,
      body: Obx(() => ListView(
            padding: EdgeInsets.only(top: 24.rpx),
            children: [
              _buildPhoneNumberTips(),
              Visibility(
                visible: state.isPhone.value,
                replacement: _buildMailboxField(),
                child: _buildPhoneField(),
              ),
              _buildVerificationCodeField(),
              Visibility(
                visible: state.currentIndex == -1,
                child: _buildVerificationMode(),
              ),
              // RecaptchaV2Button(
              //   onVerified: (value) {
              //     AppLogger.d('RecaptchaV2Button: $value');
              //   },
              //   apiKey: AppConfig.recaptchaApiKey,
              //   apiSecret: AppConfig.recaptchaApiSecret,
              //   pluginURL: AppConfig.recaptchaWebSite,
              // ),
              _buildSubmitButton(),
            ]
                .separated(
                  SizedBox(
                    height: 12.rpx,
                  ),
                )
                .toList(),
          )),
    );
  }

  Widget _buildPhoneNumberTips() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        S.current.userMethods,
        style: TextStyle(
          fontSize: 12.rpx,
          color: AppColor.black6,
        ),
      ),
    );
  }

  //绑定手机号
  Widget _buildPhoneField() {
    final locale = AppLocalization.instance.locale;
    return Container(
      height: 50.rpx,
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            S.current.phone,
            style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
          ),
          Expanded(
            child: IntlPhoneField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.current.pleaseEnterPhone,
                hintStyle: TextStyle(
                  fontSize: 14.rpx,
                  color: AppColor.gray9,
                ),
              ),
              initialCountryCode: locale?.countryCode,
              languageCode: locale?.languageCode ?? 'en',
              disableLengthCheck: true,
              dropdownIconPosition: IconPosition.trailing,
              dropdownIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: AppColor.gray5,
              ),
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: Colors.white,
                searchFieldInputDecoration:
                    InputDecoration(labelText: S.current.search),
              ),
              onChanged: (phone) {
                controller.phoneNumberInputController.text = phone.number;
                state.countryCode = phone.countryCode;
              },
            ),
          ),
        ],
      ),
    );
  }

  //绑定邮箱
  Widget _buildMailboxField() {
    return SettingTextField(
      inputController: controller.phoneNumberInputController,
      labelText: S.current.myEmail,
      hintText: S.current.pleaseEnterEmail,
      borderRadius: BorderRadius.zero,
    );
  }

  Widget _buildVerificationCodeField() {
    return SettingTextField(
      inputController: controller.verificationInputController,
      labelText: state.isPhone.value
          ? S.current.cellPhoneVerificationCode
          : S.current.cellEmailVerificationCode,
      hintText: S.current.pleaseEnterTheVerificationCode,
      borderRadius: BorderRadius.zero,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ],
      suffixIcon: LoginVerificationCodeButton(
        onFetch: state.isPhone.value
            ? controller.fetchSmsVerificationCode
            : controller.fetchEmailVerificationCode,
      ),
    );
  }

  //验证方式
  Widget _buildVerificationMode() {
    return GestureDetector(
      onTap: () {
        controller.phoneNumberInputController.clear();
        state.isPhone.value = !state.isPhone.value;
      },
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(bottom: 24.rpx, right: 16.rpx),
        child: RichText(
          text: TextSpan(
            text: "${S.current.notReceiveTheVerification}? ",
            style: TextStyle(
              fontSize: 12.rpx,
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
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return GestureDetector(
        onTap: state.isVisible.value
            ? controller.submit
            : null,
        child: Container(
          height: 42.rpx,
          decoration: BoxDecoration(
              color: AppColor.primaryBlue
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
