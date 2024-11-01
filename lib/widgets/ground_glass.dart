import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/color_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/my_vip/widget/vip_package_list_tile.dart';
import 'package:guanjia/widgets/spacing.dart';

import '../common/app_text_style.dart';
import 'app_image.dart';
import 'common_gradient_button.dart';

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

  @override
  Widget build(BuildContext context) {
    VipModel? vipInfo = SS.appConfig.configRx.value?.vipInfo;
    return Obx(() {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.7),
        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(bottom: 16.rpx),
                child: AppImage.asset("assets/images/mine/vip_close.png",width: 28.rpx,height: 28.rpx,),
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
                    padding: EdgeInsets.symmetric(vertical: 8.rpx),
                    child: Text("开通会员权益",
                      style: AppTextStyle.fs20.copyWith(color: Colors.white),
                    ),
                  ),
                  AppImage.network(vipInfo?.benefits[vipIndex.value].bigIcon ?? '',width: 220.rpx,height: 160.rpx,),
                  Text(vipInfo?.benefits[vipIndex.value].bigTitle ?? '',
                    style: AppTextStyle.fs18.copyWith(color: Colors.white),
                  ),
                  Text(vipInfo?.benefits[vipIndex.value].bigSubTitle ?? '', style: AppTextStyle.fs14.copyWith(color: Colors.white),),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.rpx)
                    ),
                    margin: EdgeInsets.only(top: 20.rpx),
                    padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 10.rpx),
                    height: 160.rpx,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(vipInfo?.packages.length ?? 0, (index) {
                        VipPackageModel pack = vipInfo!.packages[index];
                        bool select = vipIndex.value == index;
                        return [1,3,12].contains(pack.duration) ?
                            VipPackageListTile(
                            item: pack,
                            isSelected: select,
                            showDialog: true,
                            onTap: (){
                              vipIndex.value = index;
                            },
                          ):Container();
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(top: 18.rpx),
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
                  Get.toNamed(AppRoutes.myVipPage);
                },
                // onTap: ()=> callBack?.call(),
              ),
            )
          ],
        ),
      );
    });
  }
}
