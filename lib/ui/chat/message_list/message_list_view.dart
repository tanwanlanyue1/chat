import 'dart:async';

import 'package:flutter/material.dart';
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
        print('scrollControllerListener loadMoreMessage');
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

  Widget listview(
    List<ValueNotifier<ZIMKitMessage>> messageList,
  ) {
    messageList = messageList.reversed.toList();
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
                  // defaultWidget
                  return defaultMessageWidget(
                    message: message,
                    constraints: constraints,
                  );
                },
              );
            },
          ),
        ],
      );
    });
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
