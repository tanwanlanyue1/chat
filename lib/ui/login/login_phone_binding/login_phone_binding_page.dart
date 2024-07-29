import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../widgets/app_image.dart';
import 'login_phone_binding_controller.dart';

class LoginPhoneBindingPage extends GetView<LoginPhoneBindingController> {
  LoginPhoneBindingPage({super.key});

  late final state = Get.find<LoginPhoneBindingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7EFE6),
      appBar: AppBar(
        title: Text("绑定手机号", style: TextStyle(fontSize: 18.rpx)),
        backgroundColor: const Color(0xffF7EFE6),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (canPop) async {
          if (canPop) {
            return;
          }
          final result = await ConfirmDialog.show(
            message: const Text('退出绑定将无法完成登录\n确定退出吗？'),
          );
          if(result){
            Get.back();
          }
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.rpx),
              AppImage.asset("assets/images/login/login_logo.png",
                  width: 80.rpx, height: 80.rpx),
              SizedBox(height: 54.rpx),
              Text("请绑定一个手机号码，此号码可用于登录和找回密码",
                  style: TextStyle(
                    fontSize: 14.rpx,
                    color: const Color(0xFF8D310F),
                  )),
              SizedBox(height: 30.rpx),
              Container(
                width: 303.rpx,
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
                            controller: controller.accountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "请输入手机号码",
                                hintStyle: TextStyle(
                                    color: const Color(0x4D8D310F),
                                    fontSize: 14.rpx),
                                isDense: true,
                                border: InputBorder.none)))
                  ],
                ),
              ),
              SizedBox(height: 12.rpx),
              Container(
                width: 303.rpx,
                height: 46.rpx,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.rpx)),
                padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
                child: Row(
                  children: [
                    AppImage.asset("assets/images/login/login_sms.png",
                        width: 24.rpx, height: 24.rpx),
                    SizedBox(width: 8.rpx),
                    Expanded(
                        child: TextField(
                            controller: controller.smsCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "请输入验证码",
                                hintStyle: TextStyle(
                                    color: const Color(0x4D8D310F),
                                    fontSize: 14.rpx),
                                isDense: true,
                                border: InputBorder.none))),
                    Obx(() {
                      return GestureDetector(
                        onTap: () => state.isCountingDown.value
                            ? null
                            : controller.onFetchSms(),
                        child: Text(
                          state.isCountingDown() ? "${state.smsButtonText()}s" : state.smsButtonText(),
                          style: TextStyle(
                              color: const Color(0xFF8D310F), fontSize: 14.rpx),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 55.rpx),
              Obx(() {
                return TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) {
                        return states.contains(MaterialState.disabled)
                            ? const Color(0x268D310F)
                            : const Color(0xFF8D310F);
                      }),
                      minimumSize:
                          MaterialStateProperty.all(Size(280.rpx, 42.rpx)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21.rpx),
                        ),
                      ),
                      overlayColor: MaterialStateColor.resolveWith((states) {
                        return Colors.transparent;
                      }),
                    ),
                    onPressed: state.isClickBinding.value
                        ? () => controller.onBinding()
                        : null,
                    child: Text(
                      "立即绑定",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.rpx,
                          fontWeight: FontWeight.w500),
                    ));
              }),
              // SizedBox(height: 40.rpx),
              // TextButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateColor.resolveWith((states) {
              //         return const Color(0xFF8D310F);
              //       }),
              //       minimumSize: MaterialStateProperty.all(Size(280.rpx, 42.rpx)),
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(21.rpx),
              //         ),
              //       ),
              //       overlayColor: MaterialStateColor.resolveWith((states) {
              //         return Colors.transparent;
              //       }),
              //     ),
              //     onPressed: () => controller.onBinding(),
              //     child: Text(
              //       "本机号码一键绑定",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 16.rpx,
              //           fontWeight: FontWeight.w500),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
