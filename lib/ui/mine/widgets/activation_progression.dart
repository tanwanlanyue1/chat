import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';


class ActivationProgression extends StatelessWidget {
  ActivationProgression({super.key});

  final index = 0.obs;

  //进阶弹窗
  static Future<bool?> show() {
    return Get.dialog(
      ActivationProgression(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32.rpx),
                padding: EdgeInsets.only(top: 16.rpx,bottom: 24.rpx),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 16.rpx),
                        child: AppImage.asset('assets/images/common/close.png',
                          width: 24.rpx,height: 24.rpx,),
                      ),
                    ),
                    Text(S.current.identityProgression,style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
                    Container(
                      height: 1.rpx,
                      margin: EdgeInsets.all(16.rpx),
                      color: AppColor.scaffoldBackground,
                    ),
                    Text(S.current.pleaseSelectId,style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
                    Obx(() => Container(
                      padding: EdgeInsets.all(24.rpx),
                      margin: EdgeInsets.symmetric(horizontal: 16.rpx,vertical: 24.rpx),
                      color: AppColor.scaffoldBackground,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              index.value = 0;
                            },
                            child: Container(
                              width: 120.rpx,
                              height: 40.rpx,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: index.value == 0 ? AppColor.primary : Colors.white,
                                border: Border.all(color: AppColor.primary, width: 1),
                                borderRadius: BorderRadius.circular(24.rpx),
                              ),
                              child: Text(S.current.goodGirl,style: AppTextStyle.fs14m.copyWith(color: index.value == 0 ? Colors.white : AppColor.primary),),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              index.value = 1;
                            },
                            child: Container(
                              width: 120.rpx,
                              height: 40.rpx,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 16.rpx),
                              decoration: BoxDecoration(
                                color: index.value == 1 ? AppColor.primary : Colors.white,
                                border: Border.all(color: AppColor.primary, width: 1),
                                borderRadius: BorderRadius.circular(24.rpx),
                              ),
                              child: Text(S.current.brokerP,style: AppTextStyle.fs14m.copyWith(color: index.value == 1 ? Colors.white : AppColor.primary),),
                            ),
                          ),
                        ],
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                      child: CommonGradientButton(
                        height: 50.rpx,
                        text: S.current.affirm,
                        onTap: (){
                          Get.back();
                          Get.toNamed(AppRoutes.identityProgressionPage);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
