import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
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
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
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
          backgroundColor: const Color(0xFFF6F7F9),
          body: Obx(() {
            final user = state.userInfoRx();
            var order = state.orderRx();
            final hasDatingView = ChatDateViewHelper().isChatDateViewVisible(
              order: order,
              selfUser: SS.login.info,
              user: user,
            );
            return Stack(
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
                          child: Obx(() {
                            return buildMessageListView(hasDatingView: hasDatingView);
                          }),
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
                if(hasDatingView && user != null) Positioned.fill(
                  bottom: null,
                  child: ChatDateView(
                    user: user,
                    order: order,
                    onTapOrderAction: controller.onTapOrderAction,
                    onTapOrder: (order) => controller.toOrderDetail(order.id),
                  ),
                ),
              ],
            );
          }),
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

  Widget buildMessageListView({bool hasDatingView = true}) {
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
      avatarBuilder: buildAvatar,
      userInfo: controller.state.userInfoRx(),
      // backgroundBuilder: buildBackground,
      listViewPadding:
          FEdgeInsets(top: hasDatingView ? ChatDateView.height : 0),
      onPressed: (_, message, defaultAction) {
        switch (message.customType) {
          case CustomMessageType.redPacket:
            controller.onTapRedPacket(message);
            break;
          default:
            defaultAction.call();
            break;
        }
      },
      onLongPress: (_, event, message, defaultAction) => defaultAction.call(),
    );
  }

  ///AppBar
  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Obx(() {
        final conversation = state.conversationRx();
        if (conversation == null) {
          return Spacing.blank;
        }

        final defaultInfo = conversation.toChatUserModel();

        return ChatUserBuilder(
            defaultInfo: defaultInfo,
            userId: state.conversationId,
            builder: (info) {
              final userInfo = info ?? defaultInfo;
              final timestamp = conversation.lastMessage?.info.timestamp ?? 0;
              var name = timestamp > userInfo.createdAt
                  ? conversation.name
                  : userInfo.nickname;
              if (name.isEmpty) {
                name = conversation.name;
              }
              if (name.isEmpty) {
                name = userInfo.nickname;
              }
              if (name.isEmpty) {
                name = userInfo.uid;
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width - 140.rpx),
                    child: Text(name, maxLines: 1, style: AppTextStyle.fs16m),
                  ),
                  // Padding(
                  //   padding: FEdgeInsets(left: 4.rpx),
                  //   child: AppImage.asset(
                  //     "assets/images/mine/safety.png",
                  //     width: 16.rpx,
                  //     height: 16.rpx,
                  //   ),
                  // ),
                ],
              );
            });
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
