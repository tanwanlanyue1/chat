import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_call_end_content.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///通话结束对话框
class ChatCallEndDialog extends GetView<ChatCallEndDialogController> {
  static var _visible = false;
  const ChatCallEndDialog._({
    super.key,
    required this.message,
  });

  final ZIMKitMessage message;

  static void show({
    required ZIMKitMessage message,
  }) {
    if(_visible){
      return;
    }
    _visible = true;
    Get.bottomSheet(
      ChatCallEndDialog._(
        message: message,
      ),
      isScrollControlled: true,
    ).whenComplete(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final content = message.callEndContent!;
    return GetBuilder(
      init: ChatCallEndDialogController(message),
      builder: (controller) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.rpx)),
              ),
              padding: FEdgeInsets(
                all: 16.rpx,
                bottom: Get.padding.bottom + 24.rpx,
              ),
              margin: FEdgeInsets(top: 40.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildAttention(),
                  buildContent(content),
                  CommonGradientButton(
                    width: 120.rpx,
                    height: 50.rpx,
                    text: '关闭',
                    onTap: Get.back,
                  )
                ],
              ),
            ),
            buildAvatar(),
          ],
        );
      },
    );
  }

  ///是否是通话发起方
  bool get isSelfInviter =>
      message.callEndContent?.inviter == SS.login.userId;

  Widget buildAvatar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80.rpx,
          height: 80.rpx,
          clipBehavior: Clip.antiAlias,
          decoration: const ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(
                width: 1.5,
                color: Colors.white,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
          margin: FEdgeInsets(bottom: 12.rpx),
          child: ChatAvatar(
            userId: message.info.conversationID,
            width: 80.rpx,
            height: 80.rpx,
          ),
        ),
        buildNickName(),
      ],
    );
  }

  Widget buildNickName() {
    return ChatUserBuilder(userId: message.info.conversationID, builder: (info){
      return Text(
        info?.baseInfo.userName ?? '',
        style: AppTextStyle.fs14b.copyWith(
          color: AppColor.blackBlue,
          height: 1.00001,
        ),
      );
    });
  }

  ///关注
  Widget buildAttention() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          controller.toggleAttention(int.parse(message.info.conversationID));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ObxValue((isAttentionRx) {
              return Visibility(
                visible: controller.isAttentionRx(),
                replacement: AppImage.asset(
                  "assets/images/plaza/attention_no.png",
                  width: 24.rpx,
                  height: 24.rpx,
                ),
                child: AppImage.asset(
                  "assets/images/plaza/attention.png",
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              );
            }, controller.isAttentionRx),
            Container(
              padding: EdgeInsets.only(left: 4.rpx),
              child: Text(
                "关注",
                style: AppTextStyle.fs14m.copyWith(color: AppColor.black666),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent(MessageCallEndContent content) {
    Widget buildItem({
      required String label,
      required String value,
      bool isHighlight = false,
    }) {
      return Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: isHighlight
                ? const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textYellow,
                  )
                : null,
          ),
        ],
      );
    }

    List<Widget> children = [
      buildItem(
        label: '通话结束时间',
        value: DateTime.fromMillisecondsSinceEpoch(content.endTime).format2,
      ),
      buildItem(label: '本次通话时长', value: Duration(seconds: content.duration).formatHHmmss),
    ];

    if (isSelfInviter) {
      children.addAll([
        buildItem(
          label: '本次实付金额',
          value: content.amount.toCurrencyString(),
          isHighlight: true,
        ),
      ]);
    } else {
      children = [
        buildItem(
          label: '用户缴纳费用',
          value: content.amount.toCurrencyString(),
        ),
        buildItem(
          label: '平台收取比例',
          value: content.platformRate.toPercent(scale: 1),
        ),
        buildItem(
          label: '平台费',
          value: content.platformFee.toCurrencyString(),
        ),
        if(content.hasAgent) buildItem(
          label: '经纪人收取比例',
          value: (content.agentRate ?? 0).toPercent(scale: 1),
        ),
        if(content.hasAgent) buildItem(
          label: '经纪人收费',
          value: (content.agentFee ?? 0).toCurrencyString(),
        ),
        buildItem(
          label: '陪聊实收金额',
          value: content.beautyFee.toCurrencyString(),
          isHighlight: true,
        ),
      ];
    }

    return Padding(
      padding: FEdgeInsets(top: 50.rpx, bottom: 24.rpx),
      child: DefaultTextStyle(
        style: AppTextStyle.fs12m.copyWith(
          color: AppColor.black666,
          height: 1.00001,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children.separated(Spacing.h12).toList(growable: false),
        ),
      ),
    );
  }
}

class ChatCallEndDialogController extends GetxController
    with UserAttentionMixin, GetAutoDisposeMixin {
  final ZIMKitMessage message;

  ChatCallEndDialogController(this.message);

  @override
  void onInit() {
    super.onInit();
    getIsAttention(int.parse(message.info.conversationID));
  }
}
