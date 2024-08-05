import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/message_list/message_list_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_controller.dart';

///消息列表（聊天页）
class MessageListPage extends GetView<MessageListController> {
  final String conversationId;
  final ZIMConversationType conversationType;

  const MessageListPage({
    super.key,
    required this.conversationId,
    required this.conversationType,
  });

  static void go({
    required String conversationId,
    required ZIMConversationType? conversationType,
  }) {
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
        return ZIMKitMessageListPage(
          conversationID: conversationId,
          conversationType: conversationType,
          appBarBuilder: (_, __) => buildAppBar(),
          messageListBackgroundBuilder: (_, __) {
            return AppImage.asset(
              'assets/images/chat/chat_bg.png',
              fit: BoxFit.cover,
            );
          },
        );
      },
    );
  }

  AppBar? buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: ValueListenableBuilder<ZIMKitConversation>(
        valueListenable: ZIMKit().getConversation(
          state.conversationId,
          state.conversationType,
        ),
        builder: (context, conversation, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(conversation.name),
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
        },
      ),
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
}
