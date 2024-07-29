part of '../tb_websocket_client.dart';

///心跳处理和断线重连
class _TBWebSocketHeartbeat{

  //发送心跳后等待时间,如果在该时间内未收到回包，则判定连接已断开
  static const _heartbeatWaitingDuration = Duration(seconds: 10);

  //心跳时间间隔
  static const _heartbeatDuration = Duration(seconds: 10);

  //断线重连时间间隔
  static const _reconnectDuration = Duration(seconds: 3);
  final _TBWebSocketClientImpl _client;
  Timer? _timer;

  _TBWebSocketHeartbeat._(this._client){

    //监听心跳包，执行下一次
    _client.onMessageStream.listen((event) {
      if(event.actionEnum == TBWebSocketAction.heartbeat){
        _start();
      }
    });

    //监听连接状态
    _client.onStatusStream.listen((event) {
      switch(event){
        case TBWebSocketStatus.connected:
          _start();
          break;
        case TBWebSocketStatus.disconnected:
          _stop();
          _log('连接已断开,$_reconnectDuration后开始重新连接');
          _reconnect();
          break;
        default:
          break;
      }
    });

    //监听网络状态
    Connectivity().onConnectivityChanged.listen((event) {
      _log('网络状态变更,$event');
      if(event == ConnectivityResult.none){
        _stop();
      }else if(_client.status == TBWebSocketStatus.connected){
        _start();
      }else{
        _reconnect();
      }
    });
  }

  void _reconnect(){
    _timer?.cancel();
    _timer = Timer(_reconnectDuration, _client._reconnect);
  }

  void _start(){
    _timer?.cancel();

    if(_client.status != TBWebSocketStatus.connected){
      _log('未连接，不能开始心跳');
      return;
    }
    _log('${_heartbeatDuration.inSeconds}秒后开始发送心跳包');
    _timer = Timer(_heartbeatDuration, (){
      _log('发送心跳包');
      final result = _client.sendMessage(TBWebSocketMessage(action: TBWebSocketAction.heartbeat.value));
      if(result){
        _timer = Timer(_heartbeatWaitingDuration, () {
          if(_client.status == TBWebSocketStatus.connected){
            _log('未收到心跳包，判定连接已断开');
            _client._updateStatus(TBWebSocketStatus.disconnected);
          }
        });
      }else{
        _log('心跳包发送失败');
        _stop();
      }
    });
  }

  void _stop(){
    _log('心跳停止');
    _timer?.cancel();
    _timer = null;
  }

}