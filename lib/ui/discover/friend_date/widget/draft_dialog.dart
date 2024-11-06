import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/user_avatar.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../../../../common/network/api/api.dart';
import '../friend_date_controller.dart';

//征友约会-弹窗
class DraftDialog extends StatelessWidget {
  AppointmentModel item;

  DraftDialog({super.key, required this.item});

  static Future<bool?> show({required AppointmentModel item}) {
    return Get.bottomSheet(
      isScrollControlled:true,
      DraftDialog(item: item),
    );
  }
  final controller = Get.find<FriendDateController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.rpx),
          topRight: Radius.circular(16.rpx),
        )
      ),
      padding: EdgeInsets.all(16.rpx).copyWith(right: 12.rpx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar.circle(
                item.userInfo?.avatar ?? '',
                size: 30.rpx,
              ),
              SizedBox(width: 8.rpx,),
              Text(
                item.userInfo?.nickname ?? '',
                style: AppTextStyle.fs16m.copyWith(color: AppColor.black20),
              ),
              Text(
                S.current.datingFriend,
                style: AppTextStyle.fs12.copyWith(color: AppColor.black6),
              ),
              const Spacer(),
              AppImage.asset(
                'assets/images/discover/hi_call.png',
                width: 62.rpx,
                height: 24.rpx,
              ),
            ],
          ),
          Container(
            height: 20.rpx,
            margin: EdgeInsets.only(top:8.rpx,bottom: 8.rpx),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  height: 28.rpx,
                  padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                  margin: EdgeInsets.only(right: 4.rpx),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.gradientBegin,
                        AppColor.gradientEnd,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.purple8D.withOpacity(0.8),
                          blurRadius: 4.rpx,
                          offset: Offset(1.rpx, 0),
                          inset: true
                      ),
                      BoxShadow(
                          color: AppColor.purpleE1.withOpacity(0.8),
                          blurRadius: 4.rpx,
                          offset: Offset(-1.rpx, 0),
                          inset: true
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5.rpx),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/images/plaza/friend_date.json',width: 12.rpx,height: 12.rpx),
                      SizedBox(width: 2.rpx,),
                      Text(controller.typeTitle(item.type ?? 1),style: AppTextStyle.fs10m.copyWith(color: Colors.white),)
                    ],
                  ),
                ),
                ...List.generate(controller.labelSplit(item.tag ?? '').length, (index) =>
                    Padding(
                      padding: EdgeInsets.only(right: 4.rpx),
                      child: CachedNetworkImage(
                        imageUrl: controller.labelSplit(item.tag ?? '')[index],
                      ),
                    )
                ),
              ],
            ),
          ),
          Text(
            S.current.datingTime(
              CommonUtils.timestamp(item.startTime, unit: 'MM/dd HH:00'),
              CommonUtils.timestamp(item.endTime, unit: 'MM/dd HH:00'),
              CommonUtils.difference(item.startTime,item.endTime),
            ),
            style: AppTextStyle.fs12.copyWith(color: AppColor.black92),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white8,
              borderRadius: BorderRadius.circular(8.rpx)
            ),
            padding: EdgeInsets.all(8.rpx),
            margin: EdgeInsets.symmetric(vertical: 8.rpx),
            child: Text(item.content ?? '',style:AppTextStyle.fs10.copyWith(
                fontSize: 11.rpx,
                color: AppColor.black6, height: 1.3),),
          ),
          Row(
            children: [
              Visibility(
                visible: item.serviceCharge != null && item.serviceCharge != 0,
                replacement: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff808080),
                      borderRadius: BorderRadius.circular(2.rpx)
                  ),
                  width: 20.rpx,
                  height: 20.rpx,
                  alignment: Alignment.center,
                  child: Text(S.current.note,style: AppTextStyle.fs12b.copyWith(color: Colors.white),),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.redF5,
                      borderRadius: BorderRadius.circular(2.rpx)
                  ),
                  width: 20.rpx,
                  height: 20.rpx,
                  alignment: Alignment.center,
                  child: AppImage.asset("assets/images/discover/offer.png",width: 12.rpx,),
                ),
              ),
              Visibility(
                visible: item.serviceCharge != null && item.serviceCharge != 0,
                replacement: Container(
                  decoration: const BoxDecoration(
                      color: AppColor.black9
                  ),
                  padding: EdgeInsets.all(4.rpx),
                  child: Text(S.current.noServiceCharge1,style: AppTextStyle.fs10.copyWith(color: Colors.white,height: 1),),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.yellow.withOpacity(0.25)
                  ),
                  padding: EdgeInsets.all(4.rpx),
                  child: Text(S.current.provideService,style: AppTextStyle.fs10.copyWith(color: AppColor.textRed,height: 1),),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 2.rpx,left: 2.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppImage.asset("assets/images/discover/location.png",width: 16.rpx,height: 16.rpx,),
                      Text("${item.location} ${item.distance ?? 0}km",style: AppTextStyle.fs10.copyWith(color: AppColor.black92),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.scaffoldBackground,
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            padding: EdgeInsets.all(12.rpx),
            margin: EdgeInsets.only(top: 8.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.beWillingPay,
                  style:
                  AppTextStyle.fs12b.copyWith(color: AppColor.black20),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.serviceCharge,
                        style: AppTextStyle.fs12
                            .copyWith(color: AppColor.black6),
                      ),
                      Visibility(
                        visible: item.serviceCharge != null && item.serviceCharge! > 0,
                        replacement: Text(
                          S.current.freeCharge,
                          style: AppTextStyle.fs12
                              .copyWith(color: AppColor.black20),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: '\$',
                            style: AppTextStyle.fs10b.copyWith(color: AppColor.black20),
                            children: [
                              TextSpan(
                                text: "${item.serviceCharge}",
                                style: AppTextStyle.fs10b.copyWith(color: AppColor.black20,fontSize: 13.rpx),
                              )
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.earnestMoney,
                      style: AppTextStyle.fs12
                          .copyWith(color: AppColor.black6),
                    ),
                    RichText(
                      text: TextSpan(
                          text: '\$',
                          style: AppTextStyle.fs10b.copyWith(color: AppColor.gradientBegin),
                          children: [
                            TextSpan(
                              text: "${SS.appConfig.configRx()?.deposit ?? 0}",
                              style: AppTextStyle.fs10b.copyWith(color: AppColor.gradientBegin,fontSize: 13.rpx),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.rpx),
                  color: AppColor.black1A,
                  height: 2.rpx,
                ),
                Text(
                  S.current.youHavePay,
                  style:
                  AppTextStyle.fs12b.copyWith(color: AppColor.black20),
                ),
                SizedBox(height: 12.rpx),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.earnestMoney,
                      style: AppTextStyle.fs12
                          .copyWith(color: AppColor.black6),
                    ),
                    RichText(
                      text: TextSpan(
                          text: '\$',
                          style: AppTextStyle.fs10b.copyWith(color: AppColor.gradientBegin),
                          children: [
                            TextSpan(
                              text: "${SS.appConfig.configRx()?.deposit ?? 0}",
                              style: AppTextStyle.fs10b.copyWith(color: AppColor.gradientBegin,fontSize: 13.rpx),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.rpx),
            child: Text(
              S.current.inOrderToProtect,
              style: AppTextStyle.fs10.copyWith(color: AppColor.black92),
            ),
          ),
          CommonGradientButton(
            height: 50.rpx,
            text: S.current.agreeDate,
            onTap: () {
              Get.back();
              participate();
            },
          )
        ],
      ),
    );
  }

  ///参与约会
  void participate() async {
    Loading.show();
    final response = await DiscoverApi.participate(id: item.id ?? 0);
    Loading.dismiss();
    if(response.isSuccess){
      ChatManager().startChat(
        userId: item.userInfo?.uid ?? 0,
      );
    }else{
      response.showErrorMessage();
    }
  }
}
