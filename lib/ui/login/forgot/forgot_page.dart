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
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.rpx)
                  .copyWith(top: 28.rpx),
              child: isNext ? _resetWidget() : _forgotWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotWidget() {
    return Obx(() {
      final isEmailValid = state.isEmailValid.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.forgotTitle,
            style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
          ),
          SizedBox(height: 20.rpx),
          Text(
            S.current.forgotTitleTip,
            style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
          ),
          Container(
            padding: EdgeInsets.only(top: 60.rpx, bottom: 12.rpx),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: state.isEmailValid.toggle,
              behavior: HitTestBehavior.opaque,
              child: Builder(
                builder: (context) {
                  final style =
                      AppTextStyle.st.size(14.rpx).textColor(Colors.white);
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: isEmailValid
                              ? S.current.forgotNoEmail
                              : S.current.forgotNoPhone,
                        ),
                        TextSpan(
                          text: isEmailValid
                              ? S.current.forgotChangeEmail
                              : S.current.forgotChangePhone,
                          style: style.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    style: style,
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: isEmailValid,
            replacement: Container(
              height: 54.rpx,
              padding: EdgeInsets.symmetric(horizontal: 16.rpx),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              child: Row(
                children: [
                  Text(
                    S.current.phone,
                    style: AppTextStyle.st.medium
                        .size(12.rpx)
                        .textColor(AppColor.black92),
                  ),
                  SizedBox(width: 16.rpx),
                  Expanded(
                    child: IntlPhoneField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S.current.pleaseEnterPhone,
                        hintStyle:
                            AppTextStyle.st.medium.textColor(AppColor.black92),
                      ),
                      style: AppTextStyle.st.medium
                          .size(14.rpx)
                          .textColor(AppColor.black3),
                      dropdownTextStyle: AppTextStyle.st.medium
                          .size(14.rpx)
                          .textColor(AppColor.black92),
                      initialCountryCode: 'CN',
                      languageCode: "ZH",
                      disableLengthCheck: true,
                      dropdownIconPosition: IconPosition.trailing,
                      dropdownIcon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: AppColor.black92,
                      ),
                      pickerDialogStyle: PickerDialogStyle(
                          backgroundColor: Colors.white,
                          searchFieldInputDecoration:
                              InputDecoration(labelText: S.current.search)),
                      // onCountryChanged: (val) {
                      //   print("val==$val");
                      // },
                      // onChanged: (phone) {
                      //   print(phone);
                      //   // controller.phoneNumberInputController.text = phone.number;
                      //   // controller.phoneNumberInputController.text = phone.countryCode.substring(1)+phone.number;
                      // },
                    ),
                  ),
                ],
              ),
            ),
            child: LoginTextField(
              controller: controller.emailController,
              labelText: S.current.forgotEmailHint,
              keyboardType: TextInputType.emailAddress,
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 30.rpx),
          CommonGradientButton(
            onTap: controller.onTapToNext,
            text: S.current.forgotSend,
            height: 50.rpx,
          ),
          Container(
            padding: EdgeInsets.only(top: 30.rpx),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: null,
              behavior: HitTestBehavior.opaque,
              child: Builder(
                builder: (context) {
                  final style =
                      AppTextStyle.st.size(14.rpx).textColor(Colors.white);
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: S.current.otherHelp,
                        ),
                        TextSpan(
                          text: S.current.contactCustomerService,
                          style: style.copyWith(
                            decoration: TextDecoration.underline,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                    style: style,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _resetWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          backgroundColor: Colors.white,
          controller: controller.emailController,
          hintText: S.current.forgotCodeHint,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: _textFieldPadding),
        LoginTextField(
          backgroundColor: Colors.white,
          controller: controller.passwordController,
          hintText: S.current.forgotPasswordHint,
          showPasswordVisible: true,
        ),
        SizedBox(height: _textFieldPadding),
        LoginTextField(
          backgroundColor: Colors.white,
          controller: controller.passwordAgainController,
          hintText: S.current.forgotPasswordAgainHint,
          showPasswordVisible: true,
        ),
        SizedBox(height: 30.rpx),
        CommonGradientButton(
          onTap: null,
          text: S.current.forgotResetPassword,
          height: 50.rpx,
        ),
      ],
    );
  }
}
