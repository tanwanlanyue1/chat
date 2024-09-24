import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_date_view.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../common/network/api/model/talk_model.dart';

///聊天会话列表项
class ConversationListTile extends StatefulWidget {
  static double? _messageContentMaxWidth;

  final ZIMKitConversation conversation;

  const ConversationListTile({
    super.key,
    required this.conversation,
  });

  @override
  State<ConversationListTile> createState() => _ConversationListTileState();
}

class _ConversationListTileState extends State<ConversationListTile>
    with UIOrderStateMixin {
  ZIMKitConversation get conversation => widget.conversation;

  void onDelete(BuildContext context) async {
    final result = await ConfirmDialog.show(
      message: Text(S.current.deleteConversationHint),
      okButtonText: Text(S.current.deletePublisher),
    );
    if (result) {
      ZIMKit().deleteConversation(conversation.id, conversation.type);
    }
  }

  void onTap() {
    ChatManager().startChat(
      userId: int.parse(conversation.id),
    );
  }

  ///是否是订单信息
  bool get isOrderMsg {
    return conversation.lastMessage?.customType == CustomMessageType.order;
  }

  @override
  Widget build(BuildContext context) {
    final orderInfoView = isOrderMsg ? _buildOrderInfo() : null;
    return Slidable(
      key: ValueKey(conversation.id),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            label: S.current.deletePublisher,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: FEdgeInsets(all: 16.rpx),
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameAndTime(),
                    _buildMessageContent(),
                    if (orderInfoView != null) orderInfoView,
                  ].separated(Spacing.h(10)).toList(growable: false),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: FEdgeInsets(right: 16.rpx),
      child: Badge(
        backgroundColor: AppColor.primaryBlue,
        smallSize: 8.rpx,
        isLabelVisible: conversation.unreadMessageCount > 0,
        alignment: const Alignment(-1.1, -1.1),
        child: ChatAvatar(
          width: 40.rpx,
          height: 40.rpx,
          userId: conversation.id,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
      ),
    );
  }

  Widget _buildNameAndTime() {
    final time = conversation.lastMessage?.info.timestamp
        .let(DateTime.fromMillisecondsSinceEpoch);
    final name = conversation.name.isNotEmpty ? conversation.name : conversation.id;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            style: AppTextStyle.fs16b.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          ),
        ),
        if (time != null)
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              time.friendlyTime,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.grayText,
                height: 1.1,
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
    var text = message.toPlainText() ?? '';
    if (conversation.lastMessage?.isMine == false) {
      text = '— $text';
    }
    var textColor = AppColor.black3;
    if(!message.isMine){
      textColor = conversation.unreadMessageCount > 0
          ? AppColor.primaryBlue
          : AppColor.grayText;
    }

    final maxWidth = ConversationListTile._messageContentMaxWidth ??=
        Get.width - (40 + 32 + 32 + 12).rpx;
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.fs14m.copyWith(
          color: textColor,
          height: 1.05,
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
    return child;
  }

  ///订单信息
  Widget? _buildOrderInfo() {
    final message = conversation.lastMessage;
    final order = message?.orderContent?.order;
    if (message == null || order == null) {
      return null;
    }

    print('${conversation.name}====>${order.introducerId}');

    //已指派订单不显示倒计时
    if(order.introducerId.toString() == conversation.id){
      return null;
    }

    if ([OrderStatus.waitingAcceptance, OrderStatus.waitingPayment]
            .contains(order.state) &&
        order.timeout <= DateTime.now().millisecondsSinceEpoch) {
      order.state = OrderStatus.timeOut;
    }

    final uiState = getUIOrderState(order);
    if (uiState == null) {
      return null;
    }

    final children = <Widget>[];
    if (uiState.isCountdown) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '[${uiState.button}]',
            style: AppTextStyle.fs14b.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          ),
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: CountdownBuilder(
              endTime: DateTime.fromMillisecondsSinceEpoch(order.timeout),
              builder: (dur, text) {
                return Text(
                  S.current.remaining(text),
                  style: AppTextStyle.fs14m.copyWith(
                    color: AppColor.red,
                    height: 1.0,
                  ),
                );
              },
              onFinish: () {
                setState(() {
                  order.state = OrderStatus.timeOut;
                });
              },
            ),
          ),
        ],
      ));
    }

    children.add(Text(
      uiState.desc,
      style: AppTextStyle.fs14m.copyWith(
        color: AppColor.blackBlue,
        height: 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.separated(Spacing.h(10)).toList(growable: false),
    );
  }
}
