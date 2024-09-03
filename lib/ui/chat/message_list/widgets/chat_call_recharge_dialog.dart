import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///音视频通话充值提醒对话框
class ChatCallRechargeDialog extends StatelessWidget {
  final bool isVideoCall;
  final int userId;
  static var _visible = false;

  const ChatCallRechargeDialog._({
    super.key,
    required this.isVideoCall,
    required this.userId,
  });

  ///- return true 立即充值， false暂不处理， null 关闭对话框
  static Future<bool?> show({required bool isVideoCall, required int userId}) async {
    SS.appConfig.fetchData();
    SS.login.fetchMyInfo();
    if(_visible){
      return null;
    }
    _visible = true;
    return Get.dialog<bool>(
      ChatCallRechargeDialog._(isVideoCall: isVideoCall, userId: userId),
    ).whenComplete(() => _visible = false);
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
              padding: FEdgeInsets(top: 16.rpx, horizontal: 16.rpx),
              child: buildDesc(),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.scaffoldBackground,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
              ),
              margin: FEdgeInsets(horizontal: 16.rpx, top: 16.rpx),
              padding: EdgeInsets.all(24.rpx),
              child: Obx(() {
                SS.appConfig.configRx();
                SS.login.info;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '为避免聊天中断，需保留适量金库余额',
                      style: AppTextStyle.fs14b.copyWith(
                        color: AppColor.blackBlue,
                      ),
                    ),
                    if (priceHintText.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isVideoCall ? "实时视频" : "实时语音",
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.grayText),
                          ),
                          Text(
                            priceHintText,
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.primaryBlue),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          "管佳金库余额",
                          style: AppTextStyle.fs14b
                              .copyWith(color: AppColor.grayText),
                        ),
                        const Spacer(),
                        Obx(() {
                          return Text(
                            SS.login.info?.balance.toCurrencyString() ?? '',
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.primaryBlue),
                          );
                        }),
                        Padding(
                          padding: FEdgeInsets(left: 8.rpx),
                          child: Text(
                            '(余额不足)',
                            style: AppTextStyle.fs12m.copyWith(
                              color: AppColor.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ].separated(Spacing.h16).toList(),
                );
              }),
            ),
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx, top: 20.rpx, bottom: 24.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    width: 120.rpx,
                    height: 50.rpx,
                    backgroundColor: AppColor.black999,
                    onPressed: () => Get.back(result: false),
                    child: Text('暂不处理', style: AppTextStyle.fs16b),
                  ),
                  CommonGradientButton(
                    width: 120.rpx,
                    height: 50.rpx,
                    text: "立即充值",
                    textStyle: AppTextStyle.fs16b.copyWith(color: Colors.white),
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

  ///价格提示文本
  String get priceHintText {
    final config = SS.appConfig.configRx();
    final price = isVideoCall ? config?.videoChatPrice : config?.voiceChatPrice;
    if (price == null || price <= 0) {
      return '';
    }
    return '${price.toCurrencyString()}/分钟';
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
    return ChatUserBuilder(
        userId: userId.toString(),
        builder: (info) {
          return Text(
            "和${info?.baseInfo.userName}聊天中",
            style: AppTextStyle.fs16b.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          );
        });
  }
}
