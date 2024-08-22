import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/src/services/services.dart';

import 'widgets/chat_message_widget.dart';

/// 消息列表
class MessageListView extends StatefulWidget {
  const MessageListView({
    super.key,
    required this.conversationID,
    this.conversationType = ZIMConversationType.peer,
    this.onPressed,
    this.itemBuilder,
    this.messageContentBuilder,
    this.avatarBuilder,
    this.backgroundBuilder,
    this.loadingBuilder,
    this.onLongPress,
    this.errorBuilder,
    this.scrollController,
    this.theme,
    this.listViewPadding,
  });

  final String conversationID;
  final ZIMConversationType conversationType;

  final ScrollController? scrollController;

  final void Function(
    BuildContext context,
    ZIMKitMessage message,
    Function defaultAction,
  )? onPressed;

  final void Function(
    BuildContext context,
    LongPressStartDetails details,
    ZIMKitMessage message,
    Function defaultAction,
  )? onLongPress;

  final Widget Function(
    BuildContext context,
    ZIMKitMessage message,
    Widget defaultWidget,
  )? itemBuilder;

  final Widget Function(
    BuildContext context,
    ZIMKitMessage message,
    Widget defaultWidget,
  )? messageContentBuilder;

  final Widget Function(
    BuildContext context,
    ZIMKitMessage message,
    Widget defaultWidget,
  )? avatarBuilder;

  final Widget Function(
    BuildContext context,
    Widget defaultWidget,
  )? errorBuilder;

  final Widget Function(
    BuildContext context,
    Widget defaultWidget,
  )? loadingBuilder;

  final Widget Function(
    BuildContext context,
    Widget defaultWidget,
  )? backgroundBuilder;

  // theme
  final ThemeData? theme;

  final EdgeInsets? listViewPadding;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  final ScrollController _defaultScrollController = ScrollController();

  ScrollController get _scrollController =>
      widget.scrollController ?? _defaultScrollController;

  Completer? _loadMoreCompleter;

  @override
  void initState() {
    ZIMKit().clearUnreadCount(widget.conversationID, widget.conversationType);
    _scrollController.addListener(scrollControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    ZIMKit().clearUnreadCount(widget.conversationID, widget.conversationType);
    _scrollController.removeListener(scrollControllerListener);

    super.dispose();
  }

  Future<void> scrollControllerListener() async {
    if (_loadMoreCompleter == null || _loadMoreCompleter!.isCompleted) {
      if (_scrollController.position.pixels >=
          0.8 * _scrollController.position.maxScrollExtent) {
        _loadMoreCompleter = Completer();
        if (0 ==
            await ZIMKit().loadMoreMessage(
                widget.conversationID, widget.conversationType)) {
          _scrollController.removeListener(scrollControllerListener);
        }
        _loadMoreCompleter!.complete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme ?? Theme.of(context),
      child: FutureBuilder(
        future: ZIMKit().getMessageListNotifier(
          widget.conversationID,
          widget.conversationType,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ValueListenableBuilder(
              valueListenable: snapshot.data!,
              builder: (
                BuildContext context,
                List<ValueNotifier<ZIMKitMessage>> messageList,
                Widget? child,
              ) {
                ZIMKit().clearUnreadCount(
                  widget.conversationID,
                  widget.conversationType,
                );
                return listview(messageList);
              },
            );
          } else if (snapshot.hasError) {
            // TODO 未实现加载失败
            // defaultWidget
            final Widget defaultWidget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  Text(snapshot.error.toString()),
                  const Text('Load failed, please click to retry'),
                ],
              ),
            );

            // customWidget
            return GestureDetector(
              onTap: () => setState(() {}),
              child: widget.errorBuilder?.call(context, defaultWidget) ??
                  defaultWidget,
            );
          } else {
            // defaultWidget
            const Widget defaultWidget =
                Center(child: CircularProgressIndicator());

            // customWidget
            return widget.loadingBuilder?.call(context, defaultWidget) ??
                defaultWidget;
          }
        },
      ),
    );
  }


  ///处理消息
  List<ValueNotifier<ZIMKitMessage>> handleMessageList(List<ValueNotifier<ZIMKitMessage>> messageList){
    final list = <ValueNotifier<ZIMKitMessage>>[];
    final selfUserId = SS.login.userId.toString();

    messageList.forEachIndexed((index, item){
      list.insert(0, item);

      if(item.value.zim is ZIMCustomMessage){
        final zim = item.value.zim as ZIMCustomMessage;
        if(zim.subType == CustomMessageType.transfer.value){
          _handleTransferMessage(list, zim, selfUserId);
        }else if(zim.subType == CustomMessageType.redPacket.value){
          _handleRedPacketMessage(list, zim, selfUserId);
        }
      }
    });

    return list;
  }

  ///处理转账消息
  void _handleTransferMessage(List<ValueNotifier<ZIMKitMessage>> list, ZIMCustomMessage zim, String selfUserId){
    if(zim.senderUserID == selfUserId){
      //模拟一条接收方收款消息
      final receiveMoneyMsg = zim.copyWith(
          isServerMessage: false,
          isUserInserted: true,
          senderUserID: zim.conversationID,
          conversationID: zim.senderUserID,
          direction: ZIMMessageDirection.receive,
          localExtendedData: ''
      );
      list.insert(0, ValueNotifier(receiveMoneyMsg.toKIT()));
    }else{
      //模拟一条转账详情消息
      final detailsMsg = zim.copyWith(
        isServerMessage: false,
        isUserInserted: true,
      );
      detailsMsg.isHideAvatar = true;
      list.insert(0, ValueNotifier(detailsMsg.toKIT()));
    }
  }

  ///处理红包消息
  void _handleRedPacketMessage(List<ValueNotifier<ZIMKitMessage>> list, ZIMCustomMessage zim, String selfUserId){
    if(zim.senderUserID == selfUserId){
    }else{
    }
  }


Widget listview(
    List<ValueNotifier<ZIMKitMessage>> messageList,
  ) {
    messageList = handleMessageList(messageList);
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Stack(
        children: [
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: widget.backgroundBuilder
                    ?.call(context, const SizedBox.shrink()) ??
                const SizedBox.shrink(),
          ),
          ListView.builder(
            cacheExtent: constraints.maxHeight * 3,
            controller: _scrollController,
            itemCount: messageList.length,
            reverse: true,
            padding: widget.listViewPadding,
            itemBuilder: (context, index) {
              final messageNotifier = messageList[index];
              return ValueListenableBuilder(
                valueListenable: messageNotifier,
                builder: (
                  BuildContext context,
                  ZIMKitMessage message,
                  Widget? child,
                ) {
                  //两条消息发送时间相隔5分钟，显示时间
                  final prevMsgTimestamp = messageList
                          .safeElementAt(index + 1)
                          ?.value
                          .info
                          .timestamp ??
                      0;
                  if (message.info.timestamp - prevMsgTimestamp >
                      5 * 60 * 1000) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTime(message),
                        defaultMessageWidget(
                          message: message,
                          constraints: constraints,
                        )
                      ],
                    );
                  } else {
                    return defaultMessageWidget(
                      message: message,
                      constraints: constraints,
                    );
                  }
                },
              );
            },
          ),
        ],
      );
    });
  }

  Widget buildTime(ZIMKitMessage message) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(message.info.timestamp);
    var dateTimeStr = '';
    if (dateTime.isToday) {
      dateTimeStr = dateTime.formatHHmm;
    } else if (dateTime.year == DateTime.now().year) {
      dateTimeStr = dateTime.toFormat('M月dd日 HH:mm');
    } else {
      dateTimeStr = dateTime.toFormat('yyyy年M月dd日 HH:mm');
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.rpx),
      padding: EdgeInsets.symmetric(vertical: 4.rpx, horizontal: 8.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.rpx),
        color: Colors.white.withOpacity(0.4),
      ),
      child: Text(
        dateTimeStr,
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.gray5,
        ),
      ),
    );
  }

  Widget defaultMessageWidget(
      {required ZIMKitMessage message, required BoxConstraints constraints}) {
    return SizedBox(
      width: constraints.maxWidth,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
          // maxHeight: message.type == ZIMMessageType.text
          //     ? double.maxFinite
          //     : constraints.maxHeight * 0.5,
        ),
        child: ChatMessageWidget(
          key: ValueKey(message.hashCode),
          message: message,
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
          messageContentBuilder: widget.messageContentBuilder,
          avatarBuilder: widget.avatarBuilder,
        ),
      ),
    );
  }
}
