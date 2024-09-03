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

///音视频通话发起确认对话框
class ChatCallDialog extends StatelessWidget {
  final bool isVideoCall;
  final int userId;

  const ChatCallDialog._(
      {super.key, required this.isVideoCall, required this.userId});

  static Future<bool?> show({required bool isVideoCall, required int userId}) {
    SS.appConfig.fetchData();
    SS.login.fetchMyInfo();
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
              child: Obx(() {
                SS.appConfig.configRx();
                SS.login.info;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (freeChatHintText.isNotEmpty)
                      Text(
                        freeChatHintText,
                        style:
                            AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                      ),
                    if (priceHintText.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isVideoCall ? "实时视频" : "实时语音",
                            style: AppTextStyle.fs14m
                                .copyWith(color: AppColor.black6),
                          ),
                          Text(
                            priceHintText,
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.gray5),
                          ),
                        ],
                      ),
                    if (balanceHintText.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            "管佳金库余额",
                            style: AppTextStyle.fs14m
                                .copyWith(color: AppColor.black6),
                          ),
                          const Spacer(),
                          Text(
                            balanceHintText,
                            style: AppTextStyle.fs14b
                                .copyWith(color: AppColor.primary),
                          ),
                          Padding(
                            padding: FEdgeInsets(left: 8.rpx),
                            child: Text(
                              isCallable ? '(达成)' : '(未达成)',
                              style: AppTextStyle.fs12m.copyWith(
                                color: isCallable ? AppColor.green : AppColor.red,
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
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "进入聊天",
                onTap: () {
                  if(isCallable){
                    Get.back(result: true);
                  }else{
                    final minBalance = SS.appConfig.configRx()?.chatMinBalance ?? 0;
                    Loading.showToast('余额需要大于${minBalance.toCurrencyString()}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///免费聊天提示文本
  String get freeChatHintText {
    final freeSecond = SS.appConfig.configRx()?.chatFreeSecond ?? 0;
    if (freeSecond <= 0) {
      return '';
    }
    if (freeSecond % 60 == 0) {
      return '前${freeSecond ~/ 60}分钟免费聊天！';
    }
    return '前$freeSecond秒钟免费聊天！';
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

  ///余额要求
  String get balanceHintText {
    final minBalance = SS.appConfig.configRx()?.chatMinBalance ?? 0;
    if (minBalance <= 0) {
      return '';
    }
    return '>${minBalance.toCurrencyString()}';
  }

  ///是否达到可呼叫要求
  bool get isCallable {
    final minBalance = SS.appConfig.configRx()?.chatMinBalance ?? 0;
    final balance = SS.login.info?.balance ?? 0;
    return balance > minBalance;
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
