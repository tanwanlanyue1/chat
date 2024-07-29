import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'config/tb_websocket_action.dart';
import 'model/tb_websocket_message.dart';

part 'impl/tb_websocket_client_impl.dart';
part 'impl/tb_websocket_heartbeat.dart';

///WebSocket客户端
abstract class TBWebSocketClient{
  TBWebSocketClient._();

  ///是否启用日志
  static var isEnabledLogging = false;

  static final TBWebSocketClient instance = _TBWebSocketClientImpl();

  ///初始化
  void initialize();

  ///连接状态监听
  Stream<TBWebSocketStatus> get onStatusStream;

  ///当前连接状态
  TBWebSocketStatus get status;

  ///消息监听
  Stream<TBWebSocketMessage> get onMessageStream;

  ///发送消息
  ///- return 未初始化或者通道已关闭时返回false，其他情况返回true
  bool sendMessage(TBWebSocketMessage message);

  ///添加消息(模拟收到消息)
  void addMessage(TBWebSocketMessage message);

}


///WebSocket状态
enum TBWebSocketStatus{

  ///未知
  none,

  ///连接中
  connecting,

  ///已连接
  connected,

  ///已断开
  disconnected,
}
