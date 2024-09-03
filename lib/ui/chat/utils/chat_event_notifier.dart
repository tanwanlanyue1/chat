import 'dart:async';

import 'package:zego_zimkit/zego_zimkit.dart';

///聊天事件监听
class ChatEventNotifier {
  late final _onReceivePeerMessageController =
      StreamController<PeerMessageEvent>.broadcast();
  late final _onReceiveCommandMessageController =
      StreamController<PeerMessageEvent>.broadcast();

  ChatEventNotifier._() {
    _onReceivePeerMessage();
  }
  factory ChatEventNotifier() => instance;

  static final instance = ChatEventNotifier._();

  ///监听单聊消息
  void _onReceivePeerMessage() {
    final callback = ZIMEventHandler.onReceivePeerMessage;
    ZIMEventHandler.onReceivePeerMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromUserID,
    ) {
      final event = PeerMessageEvent(
        zim: zim,
        messageList: messageList,
        fromUserID: fromUserID,
      );
      //拦截信令消息，不要回调给SDK内部的方法，否则聊天页面会有信令消息
      if (messageList.firstOrNull?.type != ZIMMessageType.command) {
        callback?.call(zim, messageList, fromUserID);
        _onReceivePeerMessageController.add(event);
      } else {
        _onReceiveCommandMessageController.add(event);
      }
    };

  }

  ///监听单聊消息流
  Stream<PeerMessageEvent> get onReceivePeerMessage =>
      _onReceivePeerMessageController.stream;

  ///监听信令消息流
  Stream<PeerMessageEvent> get onReceiveCommandMessage =>
      _onReceiveCommandMessageController.stream;

}

///单聊消息事件
class PeerMessageEvent {
  final ZIM zim;
  final List<ZIMMessage> messageList;
  final String fromUserID;

  PeerMessageEvent({
    required this.zim,
    required this.messageList,
    required this.fromUserID,
  });
}
