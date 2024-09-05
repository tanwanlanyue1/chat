
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户信息缓存
class ChatUserInfoCache{
  static final instance = ChatUserInfoCache._();
  final _cache = <String,ZIMUserFullInfo>{};

  ChatUserInfoCache._();
  factory ChatUserInfoCache() => instance;

  Future<ZIMUserFullInfo> getOrQuery(String userId) async{
    var info = get(userId);
    if(info != null){
      AppLogger.d('hit cache: ${userId}');
      return info;
    }
    info = await  ZIMKit().queryUser(userId);
    _cache[userId] = info;
    return info;
  }

  ZIMUserFullInfo? get(String userId){
    return _cache[userId];
  }

  void delete(String userId){
    _cache.remove(userId);
  }

  void clear(){
    _cache.clear();
  }

}