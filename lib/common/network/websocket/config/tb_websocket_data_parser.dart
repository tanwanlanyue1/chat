
import '../tb_websocket.dart';

///消息数据解析器
typedef WebSocketDataParse = dynamic Function(dynamic data);

class TBWebSocketDataParser {
  TBWebSocketDataParser._();

  ///解析器配置
  static final _parserMap = <TBWebSocketAction, WebSocketDataParse>{
    
    ///用户模块相关信息推送
    TBWebSocketAction.user: _parser<int>(TBUserMessageData.tryParse),
    
    ///同一账号登录被踢下线
    TBWebSocketAction.kickOffline: _parser<Map<String, dynamic>>(TBKickOfflineMessageData.fromJson),
    
    ///比赛视频直播链接禁用
    TBWebSocketAction.matchLive: _parser<Map<String, dynamic>>(TBLiveLineEvent.fromJson),
  };

  static WebSocketDataParse _parser<I>(Function(I data) parse) {
    return (data) => data is I ? parse(data) : data;
  }

  static dynamic parse(TBWebSocketAction action, dynamic data) {
    try {
      return _parserMap[action]?.call(data);
    } catch (ex) {
      // TBLogger.w('数据解析失败，action=$action, data=$data');
      return null;
    }
  }
}
