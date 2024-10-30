import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/unread_badge.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../common/network/api/api.dart';

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
    final defaultInfo = ZIMUserFullInfo();
    defaultInfo.baseInfo = ZIMUserInfo()
      ..userID = conversation.id
      ..userName = conversation.name;

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
          padding: FEdgeInsets(horizontal: 16.rpx, vertical: 12.rpx),
          alignment: Alignment.centerLeft,
          child: ChatUserBuilder(
            userId: conversation.id,
            defaultInfo: defaultInfo,
            builder: (ZIMUserFullInfo? userInfo) {
              return Row(
                crossAxisAlignment: conversation.lastMessage == null
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  _buildAvatar(userInfo?.userAvatarUrl ?? ''),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNameAndTime(userInfo),
                        if (conversation.lastMessage != null)
                          _buildMessageContent(),
                        if (orderInfoView != null) orderInfoView,
                      ].separated(Spacing.h(6)).toList(growable: false),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Padding(
      padding: FEdgeInsets(right: 16.rpx),
      child: UserAvatar.circle(
        url,
        size: 40.rpx,
      ),
    );
  }

  Widget _buildNameAndTime(ZIMUserFullInfo? fullInfo) {
    final time = conversation.lastMessage?.info.timestamp
        .let(DateTime.fromMillisecondsSinceEpoch);
    final friendlyTime = time?.friendlyTime ?? '';
    var maxWidth = 0.0;
    if (friendlyTime.contains('年')) {
      maxWidth = 80.rpx;
    } else if (friendlyTime.contains('月')) {
      maxWidth = 118.rpx;
    } else if (friendlyTime.contains('小时前') || friendlyTime.contains('分钟前')) {
      maxWidth = 150.rpx;
    } else {
      maxWidth = 180.rpx;
    }

    final extendedData =
        fullInfo?.extendedDataModel ?? ZIMUserExtendDataModel.fromJson({});
    final extendedChildren = <Widget>[
      Padding(
        padding: FEdgeInsets(left: 4.rpx),
        child: AppImage.asset(
          extendedData.gender.icon,
          size: 12.rpx,
        ),
      ),
    ];
    extendedChildren.add(
      Padding(
        padding: FEdgeInsets(left: 4.rpx),
        child: OccupationWidget(occupation: UserOccupation.employees),
      ),
    );

    // //系统用户
    // if (!isSystemUser) {
    //   maxWidth += 68.rpx;
    // }

    final name = conversation.name.isNotEmpty
        ? conversation.name
        : fullInfo?.baseInfo.userName ?? conversation.id;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          // color: Colors.red,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.fs16m.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          ),
        ),
        ...extendedChildren,
        const Spacer(),
        if (time != null)
          Padding(
            padding: FEdgeInsets(left: 8.rpx, bottom: 4.rpx),
            child: Text(
              time.friendlyTime,
              style: AppTextStyle.normal.copyWith(
                fontSize: 11.rpx,
                color: AppColor.grayText,
                height: 1,
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
    final maxWidth = ConversationListTile._messageContentMaxWidth ??=
        Get.width - (40 + 32 + 32 + 12).rpx;
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(
        message.toPlainText() ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.normal.copyWith(
          fontSize: 13.rpx,
          color: AppColor.grayText,
          height: 1.1,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        child,
        ...trailingWidgets,
        const Spacer(),
        SizedBox.square(
          dimension: 16.rpx,
          child: conversation.unreadMessageCount > 0
              ? UnreadBadge(
                  unread: conversation.unreadMessageCount,
                  size: 16.rpx,
                )
              : null,
        )
      ],
    );
  }

  ///订单信息
  Widget? _buildOrderInfo() {
    final message = conversation.lastMessage;
    final order = message?.orderContent?.order;
    if (message == null || order == null) {
      return null;
    }

    //已指派订单不显示倒计时
    if (order.introducerId.toString() == conversation.id) {
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
            style: AppTextStyle.normal.copyWith(
              fontSize: 13.rpx,
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
                  style: AppTextStyle.normal.copyWith(
                    color: AppColor.red,
                    fontSize: 13.rpx,
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
      style: AppTextStyle.normal.copyWith(
        color: AppColor.grayText,
        height: 1.0,
        fontSize: 13.rpx,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.separated(Spacing.h8).toList(growable: false),
    );
  }
}
