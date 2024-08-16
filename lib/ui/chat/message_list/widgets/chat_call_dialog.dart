import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///音视频通话发起确认对话框
class ChatCallDialog extends StatelessWidget {
  final bool isVideoCall;
  final int userId;

  const ChatCallDialog._({super.key, required this.isVideoCall, required this.userId});

  static Future<bool?> show({required bool isVideoCall, required int userId}) {
    return Get.dialog<bool>(
      ChatCallDialog._(isVideoCall: isVideoCall, userId: userId),
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
              ],
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: buildDesc(),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.scaffoldBackground,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
              ),
              margin: FEdgeInsets(horizontal: 16.rpx, top: 16.rpx),
              padding: EdgeInsets.all(24.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '前1分钟免费聊天！',
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "实时语音",
                        style:
                            AppTextStyle.fs14m.copyWith(color: AppColor.black6),
                      ),
                      Text(
                        "60\$/10min",
                        style:
                            AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "管佳金库余额",
                        style: AppTextStyle.fs14m
                            .copyWith(color: AppColor.black6),
                      ),
                      Text(
                        "60\$",
                        style: AppTextStyle.fs14b
                            .copyWith(color: AppColor.primary),
                      ),
                    ],
                  ),
                ].separated(Spacing.h16).toList(),
              ),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "进入聊天",
                onTap: () {
                  Get.back(result: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildUserAvatar() {
    return ChatAvatar.circle(
      userId: userId.toString(),
      width: 60.rpx,
      height: 60.rpx,
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


  Widget buildDesc() {
    return ChatUserBuilder(userId: userId.toString(), builder: (info){
      return Text(
        isVideoCall
            ? "和${info?.baseInfo.userName}发起视频聊天？"
            : "和${info?.baseInfo.userName}发起实时语音聊天？",
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.gray5,
          height: 1.5,
        ),
      );
    });
  }
}
