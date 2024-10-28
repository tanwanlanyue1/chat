import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/loading.dart';


class ActivationProgression extends StatelessWidget {
  Function(int index)? callBack;
  ActivationProgression({super.key,this.callBack});

  UserType type = SS.login.info?.type ?? UserType.user;
  final index = 0.obs;
  //身份数组
  List idList = [
    {
      "name": S.current.customer,
      "type": UserType.user,
      "index": 0,
    },
    {
      "name": S.current.goodGirl,
      "type": UserType.beauty,
      "index": 1,
    },
    {
      "name": S.current.brokerP,
      "type": UserType.agent,
      "index": 2,
    },
  ];

  void setId(){
    for (var element in idList) {
      if(element['type'] == type){
        idList.remove(element);
        break;
      }
    }
  }

  //进阶弹窗
  static Future<bool?> show({Function(int val)? callBack}) {
    return Get.dialog(
      ActivationProgression(callBack: callBack,),
    );
  }

  @override
  Widget build(BuildContext context) {
    setId();
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
                          ...List.generate(idList.length, (i) => GestureDetector(
                            onTap: (){
                              index.value = i;
                            },
                            child: Container(
                              width: 120.rpx,
                              height: 40.rpx,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 16.rpx),
                              decoration: BoxDecoration(
                                color: index.value == i ? AppColor.gradientBegin : Colors.white,
                                border: Border.all(color: AppColor.gradientBegin, width: 1),
                                borderRadius: BorderRadius.circular(24.rpx),
                              ),
                              child: Text(idList[i]['name'],style: AppTextStyle.fs14.copyWith(color: index.value == i ? Colors.white : AppColor.gradientBegin),),
                            ),
                          ))
                        ],
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                      child: CommonGradientButton(
                        height: 50.rpx,
                        text: S.current.confirm,
                        onTap: () =>callBack?.call(idList[index.value]['index']),
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
