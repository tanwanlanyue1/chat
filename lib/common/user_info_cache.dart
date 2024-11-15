import 'dart:async';

import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';

import '../../../common/network/api/api.dart';

///用户信息缓存
class UserInfoCache {
  UserInfoCache._();

  factory UserInfoCache() => instance;
  static final instance = UserInfoCache._();

  final _cache = <int, UserModel>{};

  Future<UserModel?> getOrQuery(
    int userId, {
    bool isQueryFromServer = false,
  }) async {
    var info = get(userId);
    if (info != null && !isQueryFromServer) {
      AppLogger.d('ChatUserManager: hit cache: ${userId}');
      return info;
    }

    //从服务器获取
    if (isQueryFromServer) {
      final response = await UserApi.info(uid: userId);
      final info = response.data;
      if (info != null) {
        _cache[userId] = info;
        ChatUserManager().updateWithUserModels([info]);
        return info;
      }
    }

    return null;
  }

  UserModel? get(int userId) {
    return _cache[userId];
  }

  ///如果缓存不存在则加入
  void putIfAbsent(List<UserModel> list) {
    for (var element in list) {
      _cache.putIfAbsent(element.uid, () => element);
    }
  }

}
