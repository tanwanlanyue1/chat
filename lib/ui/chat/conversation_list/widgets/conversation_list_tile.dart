import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天会话列表项
class ConversationListTile extends StatelessWidget {
  static double? _messageContentMaxWidth;

  final ZIMKitConversation conversation;

  const ConversationListTile({
    super.key,
    required this.conversation,
  });

  void onDelete(BuildContext context) async {
    final result = await ConfirmDialog.show(
      message: Text('您确定要删除此对话吗?'),
      okButtonText: Text('删除'),
    );
    if (result) {
      ZIMKit().deleteConversation(conversation.id, conversation.type);
    }
  }

  void onTap() {
    if(conversation.customMessageType == CustomMessageType.sysNotice){
      Get.toNamed(AppRoutes.mineMessage);
      return;
    }

    Get.to(() => ZIMKitMessageListPage(
          conversationID: conversation.id,
          conversationType: conversation.type,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: conversation.customMessageType != CustomMessageType.sysNotice,
      key: ValueKey(conversation.id),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            label: '删除',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: FEdgeInsets(all: 16.rpx),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              _buildAvatar(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameAndTime(),
                    _buildMessageContent(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    var text = '${conversation.unreadMessageCount}';
    if (conversation.unreadMessageCount > 99) {
      text = '99+';
    }
    var icon = conversation.icon;
    if(conversation.customMessageType == CustomMessageType.sysNotice){
      icon = AppImage.asset('assets/images/chat/ic_sys_notice.png');
    }

    return Padding(
      padding: FEdgeInsets(right: 16.rpx),
      child: Badge(
        offset: Offset(4.rpx, -4.rpx),
        backgroundColor: AppColor.red6,
        textStyle: AppTextStyle.fs10m,
        label: Text(text),
        isLabelVisible: conversation.unreadMessageCount > 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.rpx),
          child:
          SizedBox(width: 40.rpx, height: 40.rpx, child: icon),
        ),
      ),
    );
  }

  Widget _buildNameAndTime() {
    final time = conversation.lastMessage?.info.timestamp
        .let(DateTime.fromMillisecondsSinceEpoch);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            conversation.name.isNotEmpty ? conversation.name : conversation.id,
            maxLines: 1,
            style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
          ),
        ),
        if (time != null)
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              time.friendlyTime,
              style: TextStyle(
                fontSize: 12.rpx,
                color: const Color(0xFFCCCCCC),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageContent() {
    final message = conversation.lastMessage;
    if (message == null) {
      return Spacing.blank;
    }

    final maxWidth =
        _messageContentMaxWidth ??= Get.width - (40 + 32 + 32 + 12).rpx;
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(
        conversation.toStringValue() ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.rpx,
          color: AppColor.gray9,
        ),
      ),
    );

    final trailingWidgets = <Widget>[];

    //消息发送状态图标
    Widget? statusIcon;
    if (message.info.direction == ZIMMessageDirection.send) {
      switch (message.info.sentStatus) {
        case ZIMMessageSentStatus.sending:
          statusIcon = SizedBox.square(
            dimension: 8.rpx,
            child: const CircularProgressIndicator(
              color: Colors.black12,
              strokeWidth: 2,
            ),
          );
          break;
        case ZIMMessageSentStatus.failed:
          statusIcon = Icon(Icons.error, color: Colors.red, size: 14.rpx);
          break;
        default:
          break;
      }
      statusIcon?.let(trailingWidgets.add);
    }

    if (trailingWidgets.isNotEmpty) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          child,
          ...trailingWidgets,
        ],
      );
    }
    return Padding(
      padding: FEdgeInsets(top: 4.rpx),
      child: child,
    );
  }
}

extension on ZIMKitConversation{
  String? toStringValue(){
    switch(lastMessage?.type){
      case ZIMMessageType.custom:
        switch(customMessageType){
          case CustomMessageType.sysNotice:
            return lastMessage?.customContent?.message ?? '';
          default:
            break;
        }
      default:
        return lastMessage?.toStringValue();
    }
    return null;
  }

  ///自定义消息类型
  CustomMessageType? get customMessageType{
    final customContent = lastMessage?.customContent;
    if(customContent != null) {
      return CustomMessageTypeX.valueOf(customContent.type);
    }
    return null;
  }

}
