import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';

import '../common/app_text_style.dart';
import 'app_image.dart';
import 'common_gradient_button.dart';

///毛玻璃效果
class GroundGlass extends StatelessWidget {
  Function()? callBack;
  GroundGlass({super.key,this.callBack});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
      visible: !SS.login.isVip,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            color: const Color(0xffFFFFFF).withOpacity(.3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset("assets/images/mine/vip_card.png",width: 244.rpx,height: 230.rpx,),
                Container(
                  margin: EdgeInsets.only(top: 16.rpx,bottom: 36.rpx,left: 38.rpx,right: 38.rpx),
                  padding: EdgeInsets.symmetric(vertical: 6.rpx,horizontal: 8.rpx),
                  // decoration: const BoxDecoration(
                  //   gradient: LinearGradient(
                  //     colors: [
                  //       Color(0x00FFFFFF),
                  //       Color(0x29FFFFFF),
                  //       Color(0x3DFFFFFF),
                  //       Color(0x29FFFFFF),
                  //       Color(0x00FFFFFF),
                  //     ],
                  //     begin: Alignment.centerLeft,
                  //     end: Alignment.centerRight,
                  //   ),
                  // ),
                  child: Text(S.current.openVipTips,
                    style: AppTextStyle.fs16m.copyWith(color: Colors.black,height: 1.5,
                        shadows: [Shadow(color: Colors.white.withOpacity(0.9), offset: const Offset(0,0), blurRadius: 2)]
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 38.rpx),
                  child: CommonGradientButton(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.current.openVipNow,
                          style: AppTextStyle.fs16m.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 8.rpx,),
                        AppImage.asset("assets/images/mine/ic_vip.png",width: 24.rpx,height: 24.rpx,),
                      ],
                    ),
                    height: 50.rpx,
                    onTap: (){
                      Get.toNamed(AppRoutes.myVipPage);
                    },
                    // onTap: ()=> callBack?.call(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
