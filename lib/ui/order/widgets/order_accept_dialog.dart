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

///佳丽接单对话框
class OrderAcceptDialog extends StatelessWidget {
  final int userId;
  const OrderAcceptDialog._({super.key, required this.userId});

  ///接单对话框
  ///- true接受， false拒绝， null关闭对话框
  static Future<bool?> show({required int userId}) {
    return Get.dialog<bool>(
      OrderAcceptDialog._(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Wrap(
              spacing: -13.rpx,
              children: [
                buildUserAvatar(),
                buildSelfAvatar(),
              ]
            ),
            Padding(
              padding: FEdgeInsets(top: 14.rpx, horizontal: 16.rpx),
              child: buildDesc(),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: Text(
                S.current.inOrderToProtect,
                style: AppTextStyle.fs12.copyWith(
                  color: AppColor.grayText,
                  height: 1.5,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    backgroundColor: AppColor.gray9,
                    width: 120.rpx,
                    height: 50.rpx,
                    child: Text(
                      S.current.refuse,
                      style: AppTextStyle.fs16,
                    ),
                  ),
                  CommonGradientButton(
                    width: 120.rpx,
                    height: 50.rpx,
                    text: S.current.acceptanceAppointment,
                    onTap: () {
                      Get.back(result: true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
      userId: userId.toString(),
      size: 60.rpx,
    );
  }

  Widget buildDesc() {
    return ChatUserBuilder(userId: userId.toString(), builder: (info){
      return Text(
        '${S.current.agreedSum} ${info?.baseInfo.userName} ${S.current.appointment}？',
        textAlign: TextAlign.center,
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.blackBlue,
          height: 1.5,
        ),
      );
    });
  }
}
