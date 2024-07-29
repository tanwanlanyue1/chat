part of '../tb_websocket_client.dart';

class _TBWebSocketClientImpl extends TBWebSocketClient{
  final _messageStreamController = StreamController<TBWebSocketMessage>.broadcast();
  final _statusStreamController = StreamController<TBWebSocketStatus>.broadcast();
  WebSocketChannel? _webSocketChannel;
  var _status = TBWebSocketStatus.none;
  _TBWebSocketHeartbeat? _heartbeat;
  String? _url;

  _TBWebSocketClientImpl(): super._();

  //初始化
  @override
  void initialize() async{
    Server server;
    if(AppInfo.isRelease){
      server = ServerConfig.instance.getDefaultServer();
    }else{
      server = await ServerConfig.instance.getServer();
    }
    _heartbeat ??= _TBWebSocketHeartbeat._(this);
    final url = server.ws.toString();
    if(_url != url){
      _url = url;
      _connect(url);
    }
  }

  ///连接状态监听
  @override
  Stream<TBWebSocketStatus> get onStatusStream => _statusStreamController.stream;

  ///当前连接状态
  @override
  TBWebSocketStatus get status => _status;

  ///消息监听
  @override
  Stream<TBWebSocketMessage> get onMessageStream => _messageStreamController.stream;

  ///发送消息
  ///- return 未初始化或者通道已关闭时返回false，其他情况返回true
  @override
  bool sendMessage(TBWebSocketMessage message){
    if(_webSocketChannel == null || _webSocketChannel?.closeCode != null){
      return false;
    }else{
      _log('sendMessage: ${message.toJson()}');
      _webSocketChannel?.sink.add(jsonEncode(message.toJson()));
      return true;
    }
  }

  ///添加消息(模拟收到消息)
  @override
  void addMessage(TBWebSocketMessage message){
    _messageStreamController.add(message);
  }

  ///连接
  void _connect(String url){
    _log('开始连接, url=$url');
    _updateStatus(TBWebSocketStatus.connecting);
    _webSocketChannel?.sink.close();
    // _webSocketChannel = WebSocketChannel.connect(Uri.parse(url));
    _webSocketChannel?.stream.listen((event) {
      _log('onData $event');
      try{
        final json = jsonDecode(event);
        if(json is Map<String, dynamic>){
          _messageStreamController.add(TBWebSocketMessage.fromJson(json));
        }
      }catch(ex){
        _log('消息解析失败, event=$event, err=$ex');
        return;
      }
    }, onDone: (){
      _log('onDone');
      _updateStatus(TBWebSocketStatus.disconnected);
    }, onError: (err){
      _log('onError $err');
      _updateStatus(TBWebSocketStatus.disconnected);
    });
    _webSocketChannel?.ready.then((_){
      _log('连接 ok');
      _updateStatus(TBWebSocketStatus.connected);
      //发送初始化指令
      sendMessage(TBWebSocketMessage(action: TBWebSocketAction.initialize.value));
    }).catchError((ex){
      _log('连接 error=$ex');
      _updateStatus(TBWebSocketStatus.disconnected);
    });
  }

  void _reconnect(){
    if(_url != null){
      _connect(_url!);
    }
  }

  ///更新连接状态
  void _updateStatus(TBWebSocketStatus status){
    if(_status != status){
      _log('更新连接状态: prevStatus=$_status, currentStatus = $status');
      _status = status;
      _statusStreamController.add(status);
    }
  }
  
}

void _log(dynamic msg){
  if(TBWebSocketClient.isEnabledLogging){
    // TBLogger.d('WebSocketClient: $msg');
  }
}