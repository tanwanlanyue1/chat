import 'dart:async';

import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';

import '../../../common/network/api/api.dart';

///用户信息缓存
class UserInfoCache {
  UserInfoCache._();

  factory UserInfoCache() => instance;
  static final instance = UserInfoCache._();

  final _cache = <int, _CacheData>{};

  ///- userId
  ///- isQueryFromServer 是否强制从服务端获取
  ///- ttlMs 缓存有效期(ms)，超过则从服务端获取，null则永久有效
  Future<UserModel?> getOrQuery(
    final int userId, {
    final bool isQueryFromServer = false,
    final int? ttlMs,
  }) async {

    if(isQueryFromServer){
      return _pull(userId);
    }

    final result = _cache[userId];
    if (result != null) {

      if(ttlMs == null){
        return result.data;
      }

      if(DateTime.now().millisecondsSinceEpoch - result.createdAt <= ttlMs){
        return result.data;
      }
    }

    return _pull(userId);
  }

  Future<UserModel?> _pull(int userId) async{
    final response = await UserApi.info(uid: userId);
    final info = response.data;
    if (info != null) {
      _cache[userId] = _CacheData(info, DateTime.now().millisecondsSinceEpoch);
      ChatUserManager().updateWithUserModels([info]);
      return info;
    }
    return null;
  }

  UserModel? get(int userId) {
    return _cache[userId]?.data;
  }

  ///如果缓存不存在则加入
  void putIfAbsent(List<UserModel> list) {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var element in list) {
      _cache.putIfAbsent(element.uid, () => _CacheData(element, now));
    }
  }
}

class _CacheData {
  final UserModel data;
  final int createdAt;

  _CacheData(this.data, this.createdAt);
}
