import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/color_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/my_vip/widget/vip_package_list_tile.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/spacing.dart';

import '../common/app_text_style.dart';
import '../ui/plaza/user_center/widget/swiper_pagination.dart';
import 'app_image.dart';
import 'common_gradient_button.dart';
import 'web/web_page.dart';

///快捷开通vip
class GroundGlass extends StatelessWidget {
  Function()? callBack;
  GroundGlass({super.key,this.callBack});

  static Future<void> show({Function()? callBack}) async {
    Get.dialog<int>(
      GroundGlass(callBack: callBack),
      useSafeArea: false,
    );
  }

  final vipIndex= 0.obs;
  final selectIndex= 0.obs;

  @override
  Widget build(BuildContext context) {
    VipModel? vipInfo = SS.appConfig.configRx.value?.vipInfo;
    return Obx(() {
      return GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.7),
          padding: EdgeInsets.symmetric(horizontal: 16.rpx),
          child: GestureDetector(
            onTap: (){},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(bottom: 12.rpx),
                    child: AppImage.asset("assets/images/mine/vip_close.png",width: 24.rpx,height: 24.rpx,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorUtil.fromHex(SS.appConfig.configRx.value?.vipInfo?.benefits[vipIndex.value].color ?? ''),
                    borderRadius: BorderRadius.circular(16.rpx),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.rpx,vertical: 16.rpx),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.rpx,bottom: 16.rpx),
                        child: Text("开通会员权益",
                          style: AppTextStyle.fs20.copyWith(color: Colors.white,height: 1.0),
                        ),
                      ),
                      SizedBox(
                        height: 216.rpx,
                        child: Swiper(
                          itemBuilder: (_,index){
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 12.rpx),
                                  child: AppImage.network(vipInfo?.benefits[vipIndex.value].bigIcon ?? '',width: 180.rpx,height: 130.rpx,),
                                ),
                                Text(vipInfo?.benefits[vipIndex.value].bigTitle ?? '', style: AppTextStyle.fs18.copyWith(color: Colors.white,height: 1.0),),
                                SizedBox(height: 10.rpx,),
                                Text(vipInfo?.benefits[vipIndex.value].bigSubTitle ?? '', style: AppTextStyle.fs14.copyWith(color: Colors.white,height: 1.0),),
                              ],
                            );
                          },
                          autoplay: true,
                          itemCount: vipInfo?.benefits.length ?? 0,
                          pagination: (vipInfo?.benefits.length ?? 0) > 1 ?
                          SwiperPagination(
                              margin: EdgeInsets.only(bottom: 12.rpx,right: 16.rpx),
                              builder: UserSwiperPagination(
                                color: Colors.white,
                                size: 4.rpx,
                                activeSize:4.rpx,
                                space: 4.rpx,
                                activeColor: Colors.white.withOpacity(0.5),
                              )
                          ):null,
                          onIndexChanged: (val){
                            vipIndex.value = val;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.rpx)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                        height: 152.rpx,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(vipInfo?.packages.length ?? 0, (index) {
                            VipPackageModel pack = vipInfo!.packages[index];
                            bool select = selectIndex.value == index;
                            return [1,3,12].contains(pack.duration) ?
                            VipPackageListTile(
                              item: pack,
                              isSelected: select,
                              showDialog: true,
                              onTap: (){
                                selectIndex.value = index;
                              },
                            ):Container();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(top: 18.rpx,bottom: 16.rpx),
                  child: CommonGradientButton(
                    borderRadius: BorderRadius.circular(24.rpx),
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.current.openVipNow,
                          style: AppTextStyle.fs16.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 8.rpx,),
                        AppImage.asset("assets/images/mine/ic_vip.png",width: 24.rpx,height: 24.rpx,),
                      ],
                    ),
                    height: 50.rpx,
                    onTap: (){
                      Get.back();
                      Get.toNamed(AppRoutes.orderPaymentPage, arguments: {
                        "type": OrderPaymentType.vip,
                        "vipPackage": vipInfo!.packages[selectIndex.value],
                      });
                    },
                  ),
                ),
                Text("${vipInfo!.packages[selectIndex.value].duration*30}天会员权益，开通时效越长，优惠越多哦～", style: AppTextStyle.fs12.copyWith(color: Colors.white.withOpacity(0.8)),),
                SizedBox(height: 16.rpx,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("点击立即开通即表示同意", style: AppTextStyle.fs10.copyWith(color: Colors.white.withOpacity(0.8),height: 1.0),),
                    GestureDetector(
                      onTap: (){
                        WebPage.go(url: AppConfig.urlPrivacyPolicy);
                      },
                      child: Text(S.current.privacyPolicy, style: AppTextStyle.fs12.copyWith(color: Colors.white,height: 1.0),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
