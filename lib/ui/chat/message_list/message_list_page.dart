import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/ui/chat/message_list/message_list_state.dart';
import 'package:guanjia/ui/chat/message_list/message_order_part.dart';
import 'package:guanjia/ui/chat/message_list/message_sender_part.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_date_view.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_feature_panel.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_red_packet_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_controller.dart';
import 'message_list_view.dart';
import 'widgets/chat_call_button.dart';
import 'widgets/chat_input_view.dart';

///消息列表（聊天页）
class MessageListPage extends GetView<MessageListController> {
  final String conversationId;
  final ZIMConversationType conversationType;

  const MessageListPage({
    super.key,
    required this.conversationId,
    required this.conversationType,
  });

  @override
  String? get tag => conversationId;

  MessageListState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MessageListController(
        conversationId: conversationId,
        conversationType: conversationType,
      ),
      tag: tag,
      builder: (controller) {
        return Scaffold(
          appBar: buildAppBar(context),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.chatInputViewKey.currentState
                              ?.closePanel();
                        },
                        child: buildMessageListView(),
                      ),
                    ),
                    ObxValue((dataRx) {
                      return ChatInputView(
                        key: controller.chatInputViewKey,
                        onSend: controller.sendTextMessage,
                        onTapFeatureAction: controller.onTapFeatureAction,
                        featureActions: dataRx(),
                        featureItemBuilder: buildFeatureItem,
                      );
                    }, state.featureActionsRx),
                    // messageInput(),
                  ],
                ),
              ),
              Positioned.fill(
                bottom: null,
                child: Obx(() {
                  final user = state.userInfoRx();
                  var order = state.orderRx();
                  if (user == null) {
                    return Spacing.blank;
                  }
                  return ChatDateView(
                    user: user,
                    order: order,
                    onTapOrderAction: controller.onTapOrderAction,
                    onTapOrder: (order) => controller.toOrderDetail(order.id),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFeatureItem(
      BuildContext context, Widget defaultWidget, ChatFeatureAction action) {
    if ([ChatFeatureAction.voiceCall, ChatFeatureAction.videoCall]
        .contains(action)) {
      final isVideoCall = action == ChatFeatureAction.videoCall;
      return ChatCallButton(
        isVideoCall: isVideoCall,
        userId: int.parse(conversationId),
        nickname: state.conversationRx()?.name ?? '',
        child: defaultWidget,
      );
    }
    return defaultWidget;
  }

  Widget buildMessageListView() {
    return MessageListView(
      key: ValueKey(
        'ZIMKitMessageListView:${Object.hash(
          conversationId,
          conversationType,
        )}',
      ),
      scrollController: controller.scrollController,
      conversationID: conversationId,
      conversationType: conversationType,
      itemBuilder: buildMessageItem,
      avatarBuilder: buildAvatar,
      backgroundBuilder: buildBackground,
      listViewPadding: FEdgeInsets(top: ChatDateView.height),
      onPressed: (_, message, defaultAction) {
        switch(message.customType){
          case CustomMessageType.redPacket:
            controller.onTapRedPacket(message);
            break;
          default:
            defaultAction.call();
            break;
        }
      },
    );
  }

  ///AppBar
  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Obx(() {
        final conversation = state.conversationRx();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width - 150.rpx),
              child: Text(conversation?.name ?? '', maxLines: 1),
            ),
            Padding(
              padding: FEdgeInsets(left: 4.rpx),
              child: AppImage.asset(
                "assets/images/mine/safety.png",
                width: 16.rpx,
                height: 16.rpx,
              ),
            ),
          ],
        );
      }),
      actions: [
        IconButton(
          onPressed: () => controller.showMoreBottomSheet(),
          icon: AppImage.asset(
            'assets/images/mine/more.png',
            width: 24.rpx,
            height: 24.rpx,
          ),
        ),
      ],
    );
  }

  Widget buildBackground(_, __) {
    return AppImage.asset(
      'assets/images/chat/chat_bg.png',
      fit: BoxFit.cover,
    );
  }

  ///消息列表项
  Widget buildMessageItem(_, ZIMKitMessage message, Widget defaultChild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defaultChild,
        Container(
          margin: FEdgeInsets(top: 4.rpx, bottom: 8.rpx),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              DateTime.fromMillisecondsSinceEpoch(message.info.timestamp)
                  .friendlyTime,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.black92,
                height: 1.0001,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAvatar(_, ZIMKitMessage message, Widget defaultChild) {
    if (message.customType == CustomMessageType.redPacket) {
      return ChatRedPacketBuilder(
          message: message,
          builder: (_) {
            return Visibility(
              visible: !message.isHideAvatar &&
                  [0, 1].contains(message.redPacketLocal.status),
              replacement: SizedBox(
                width: 40.rpx,
                height: 40.rpx,
              ),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.userCenterPage, arguments: {
                  'userId': int.tryParse(message.info.senderUserID),
                }),
                child: defaultChild,
              ),
            );
          });
    }

    return Visibility(
      visible: !message.isHideAvatar,
      replacement: SizedBox(
        width: 40.rpx,
        height: 40.rpx,
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.userCenterPage, arguments: {
          'userId': int.tryParse(message.info.senderUserID),
        }),
        child: defaultChild,
      ),
    );
  }
}
