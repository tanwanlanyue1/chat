import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///取消订单确认弹窗
class OrderCancelDialog extends StatelessWidget {
  int id;
  OrderCancelDialog._({super.key,required this.id});

  static Future<bool?> show(int id) {
    return Get.dialog<bool>(
      OrderCancelDialog._(id: id,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: SizedBox(
          width: 311.rpx,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleBar(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: -13.rpx,
                      children: [
                        buildUserAvatar(),
                        buildSelfAvatar(),
                      ],
                    ),
                    SizedBox(height: 16.rpx,),
                    Text(
                      S.current.areYouSure,
                      style: AppTextStyle.fs16b.copyWith(
                        color: AppColor.blackBlue,
                      ),
                    ),
                    Padding(
                      padding: FEdgeInsets(top: 12.rpx, bottom: 24.rpx),
                      child: Text(
                        "注：如约会双方均已缴纳保证金，则取消约会将需支付违约金。",
                        style: AppTextStyle.fs12m.copyWith(
                          color: AppColor.black92,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonGradientButton(
                          height: 50.rpx,
                          width: 120.rpx,
                          text: "我再想想",
                          onTap: Get.back,
                          textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white),
                        ),
                        Button(
                          onPressed: () => Get.back(result: true),
                          height: 50.rpx,
                          width: 120.rpx,
                          backgroundColor: AppColor.gray9,
                          child: Text(
                              "确定取消订单",
                              style: AppTextStyle.fs16m
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleBar() {
    return Container(
      alignment: Alignment.topRight,
      padding: FEdgeInsets(top: 4.rpx, right: 4.rpx),
      child: IconButton(
        icon: const Icon(Icons.close, color: AppColor.gray5),
        onPressed: Get.back,
      ),
    );
  }


  Widget buildSelfAvatar() {
    return AppImage.network(
      SS.login.info?.avatar ?? '',
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }

  Widget buildUserAvatar() {
    return ChatAvatar.circle(
      userId: id.toString(),
      width: 60.rpx,
      height: 60.rpx,
    );
  }

  Widget buildDesc() {
    return ChatUserBuilder(userId: id.toString(), builder: (info){
      return Text(
        S.current.sureToInitiateDateWith(info?.baseInfo.userName ?? ''),
        textAlign: TextAlign.center,
        style: AppTextStyle.fs14b.copyWith(
          color: AppColor.blackBlue,
          height: 1.5,
        ),
      );
    });
  }
}
