import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/message_list/message_list_state.dart';
import 'package:guanjia/ui/chat/message_list/message_sender_helper.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_date_view.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_feature_panel.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_controller.dart';
import 'message_list_view.dart';
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

  ///跳转聊天
  ///- conversationId 用户ID
  static void go({
    required String conversationId,
    required ZIMConversationType? conversationType,
  }) {
    if(conversationId == SS.login.userId.toString()){
      AppLogger.w('不可和自己聊天');
      return;
    }

    Get.toNamed(
      AppRoutes.messageListPage,
      arguments: {
        'conversationId': conversationId,
        'conversationType': conversationType,
      },
    );
  }

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
                    Expanded(child: buildMessageListView()),
                    ChatInputView(
                      onSend: controller.sendTextMessage,
                      onTapFeatureAction: controller.onTapFeatureAction,
                      featureActions: state.featureActions,
                      featureItemBuilder: buildFeatureItem,
                    ),
                    // messageInput(),
                  ],
                ),
              ),
              //TODO 对方是佳丽或者经纪人才需要显示
              const Positioned.fill(
                bottom: null,
                child: ChatDateView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFeatureItem(BuildContext context, Widget defaultWidget, ChatFeatureAction action) {
    if ([ChatFeatureAction.voiceCall, ChatFeatureAction.videoCall]
        .contains(action)) {
      final isVideoCall = action == ChatFeatureAction.videoCall;
      return Stack(
        alignment: Alignment.center,
        children: [
          defaultWidget,
          ZegoSendCallInvitationButton(
            iconVisible: false,
            isVideoCall: isVideoCall,
            invitees: [
              ZegoUIKitUser(
                id: conversationId,
                name: state.conversationRx()?.name ?? '',
              ),
            ],
            onWillPressed: () => controller.onWillOutgoingCall(isVideoCall),
            onPressed: (String code, String message, List<String> errorInvitees) {
              onCallInvitationSent(context, code, message, errorInvitees);
            },
          ),
        ],
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
      // onPressed: widget.onMessageItemPressed,
      itemBuilder: buildMessageItem,
      backgroundBuilder: buildBackground,
      listViewPadding: FEdgeInsets(top: ChatDateView.height),
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
            Text(conversation?.name ?? ''),
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

  void onCallInvitationSent(BuildContext context, String code, String message,
      List<String> errorInvitees) {
    late String log;
    if (errorInvitees.isNotEmpty) {
      log = "User doesn't exist or is offline: ${errorInvitees[0]}";
      if (code.isNotEmpty) {
        log += ', code: $code, message:$message';
      }
    } else if (code.isNotEmpty) {
      log = 'code: $code, message:$message';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(log)),
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
}
