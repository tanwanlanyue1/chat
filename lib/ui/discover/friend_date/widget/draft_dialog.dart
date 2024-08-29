import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/discover_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../../common/network/api/api.dart';

//征友约会-弹窗
class DraftDialog extends StatelessWidget {
  AppointmentModel item;

  DraftDialog({super.key, required this.item});

  static Future<bool?> show({required AppointmentModel item}) {
    return Get.dialog(
      DraftDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 331.rpx,
            height: 520.rpx,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            padding: EdgeInsets.all(16.rpx),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: AppImage.asset(
                      'assets/images/common/close.png',
                      width: 24.rpx,
                      height: 24.rpx,
                    ),
                  ),
                ),
                Wrap(
                  spacing: -13.rpx,
                  children: [
                    AppImage.network(
                      item.userInfo?.avatar ?? '',
                      width: 60.rpx,
                      height: 60.rpx,
                      shape: BoxShape.circle,
                    ),
                    AppImage.network(
                      SS.login.info?.avatar ?? '',
                      width: 60.rpx,
                      height: 60.rpx,
                      shape: BoxShape.circle,
                    )
                  ],
                ),
                SizedBox(height: 12.rpx),
                Text(
                  "同意和${item.userInfo?.nickname ?? ''}约会？",
                  style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.rpx),
                  child: Text(
                    "注：为保障权益，约会双方均需缴纳保证金，保证金在订单结束后将会原路退回。",
                    style: AppTextStyle.fs12m.copyWith(color: AppColor.black92),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                  ),
                  padding: EdgeInsets.all(24.rpx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ta愿支付",
                        style:
                            AppTextStyle.fs14b.copyWith(color: AppColor.black20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.rpx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "服务费",
                              style: AppTextStyle.fs14m
                                  .copyWith(color: AppColor.black6),
                            ),
                            Text(
                              (item.serviceCharge != null && item.serviceCharge! > 0) ? "\$${item.serviceCharge}":"免费",
                              style: AppTextStyle.fs14b
                                  .copyWith(color: AppColor.black20),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "保证金",
                            style: AppTextStyle.fs14m
                                .copyWith(color: AppColor.black6),
                          ),
                          Text(
                            "\$${SS.appConfig.configRx()?.deposit ?? 0}",
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.gradientBegin),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.rpx),
                        color: AppColor.black1A,
                        height: 2.rpx,
                      ),
                      Text(
                        "你需支付",
                        style:
                            AppTextStyle.fs14b.copyWith(color: AppColor.black20),
                      ),
                      SizedBox(height: 16.rpx),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "保证金",
                            style: AppTextStyle.fs14m
                                .copyWith(color: AppColor.black6),
                          ),
                          Text(
                            "\$${SS.appConfig.configRx()?.deposit ?? 0}",
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.gradientBegin),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CommonGradientButton(
                  height: 50.rpx,
                  text: "同意约会",
                  onTap: () {
                    Get.back();
                    participate();
                  },
                )
              ],
            ),
          ),
        ),
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
