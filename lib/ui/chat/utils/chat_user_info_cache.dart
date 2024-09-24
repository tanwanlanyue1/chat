import 'dart:async';

import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户信息缓存
class ChatUserInfoCache {
  static final instance = ChatUserInfoCache._();
  final _cache = <String, ZIMUserFullInfo>{};
  final _streamController = StreamController<ZIMUserFullInfo>.broadcast();

  ChatUserInfoCache._();

  factory ChatUserInfoCache() => instance;

  Future<ZIMUserFullInfo> getOrQuery(String userId) async {
    var info = get(userId);
    if (info != null) {
      AppLogger.d('hit cache: ${userId}');
      return info;
    }
    info = await ZIMKit().queryUser(userId);
    _cache[userId] = info;
    return info;
  }

  ZIMUserFullInfo? get(String userId) {
    return _cache[userId];
  }

  ///用户信息流
  Stream<ZIMUserFullInfo> get userInfoStream => _streamController.stream;

  void updateWithUserModel(UserModel userModel) {
    final userId = userModel.uid.toString();
    final nickname = userModel.nickname;
    final avatar = userModel.avatar;
    var user = get(userId);
    var update = false;
    if(user == null){
      final info = ZIMUserInfo()
          ..userAvatarUrl = avatar ?? ''
          ..userID = userId
          ..userName = nickname;
      user = ZIMUserFullInfo()
          ..userAvatarUrl = avatar ?? ''
          ..baseInfo = info;
      update = true;
    }else{
      if(nickname.isNotEmpty && user.baseInfo.userName != nickname){
        user.baseInfo.userName = nickname;
        update = true;
      }
      if(avatar != null && avatar.isNotEmpty && user.baseInfo.userAvatarUrl != avatar){
        user.userAvatarUrl = avatar;
        user.baseInfo.userAvatarUrl = avatar;
        update = true;
      }
    }
    if(update){
      _cache[userId] = user;
      _streamController.add(user);
    }
  }

  void delete(String userId) {
    _cache.remove(userId);
  }

  void clear() {
    _cache.clear();
  }
}
