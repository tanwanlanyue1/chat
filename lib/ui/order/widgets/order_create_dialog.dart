import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///客户发起约会-弹窗
class OrderCreateDialog extends StatelessWidget {
  final int userId;

  const OrderCreateDialog._({super.key, required this.userId});

  static void show({required int userId}) {
    Get.dialog(
      OrderCreateDialog._(
        userId: userId,
      ),
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
                buildSelfAvatar(),
                buildUserAvatar(),
              ],
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: buildDesc(),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "发起约会",
                onTap: () {
                  Get.back();
                },
              ),
            )
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
    return ClipOval(
      child: ZIMKitAvatar(
        userID: userId.toString(),
        width: 60.rpx,
        height: 60.rpx,
      ),
    );
  }

  Widget buildDesc() {
    final notifier = ZIMKit().getConversation(
      userId.toString(),
      ZIMConversationType.peer,
    );
    return ListenableBuilder(
      listenable: notifier,
      builder: (_, __) {
        final name = notifier.value.name;
        return Text(
          '确定和 $name 发起约会？\n点击确定后系统将向其发送约会邀约。',
          style: AppTextStyle.fs14m.copyWith(
            color: AppColor.gray5,
            height: 1.5,
          ),
        );
      },
    );
  }
}
