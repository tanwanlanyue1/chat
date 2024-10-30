import 'dart:async';
import 'dart:convert';

import 'package:guanjia/common/extension/iterable_extension.dart';
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

  Future<ZIMUserFullInfo> getOrQuery(String userId,
      {bool isQueryFromServer = false}) async {
    var info = get(userId);
    if (info != null) {
      AppLogger.d('hit cache: ${userId}');
      return info;
    }

    //从服务器获取
    if (isQueryFromServer) {
      final results = await ZIM.getInstance()?.queryUsersInfo(
        [userId.toString()],
        ZIMUserInfoQueryConfig()..isQueryFromServer = true,
      );
      info = results?.userList.firstOrNull;
      if (info != null) {
        _cache[userId] = info;
        return info;
      }
    }

    //本地获取
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
    if (user == null) {
      final info = ZIMUserInfo()
        ..userAvatarUrl = avatar ?? ''
        ..userID = userId
        ..userName = nickname;
      user = ZIMUserFullInfo()
        ..userAvatarUrl = avatar ?? ''
        ..baseInfo = info;
      update = true;
    } else {
      if (nickname.isNotEmpty && user.baseInfo.userName != nickname) {
        user.baseInfo.userName = nickname;
        update = true;
      }
      if (avatar != null &&
          avatar.isNotEmpty &&
          user.baseInfo.userAvatarUrl != avatar) {
        user.userAvatarUrl = avatar;
        user.baseInfo.userAvatarUrl = avatar;
        update = true;
      }
    }
    if (update) {
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

extension ZIMUserFullInfoExt on ZIMUserFullInfo {

  ///扩展数据Model
  ZIMUserExtendDataModel? get extendedDataModel{
    if(extendedData.isNotEmpty){
      try{
        final json = jsonDecode(extendedData);
        if(json != null){
          return ZIMUserExtendDataModel.fromJson(json);
        }
      }catch(ex){
        AppLogger.w('解析ZIMUserFullInfo扩展数据失败');
      }
    }
    return null;
  }
}

///ZIM用户扩展数据
class ZIMUserExtendDataModel {

  ///职业
  final UserOccupation occupation;

  ///性别
  final UserGender gender;

  final String? vip;

  ZIMUserExtendDataModel({required this.occupation, required this.gender, this.vip});

  factory ZIMUserExtendDataModel.fromJson(Map<String, dynamic> json) {
    return ZIMUserExtendDataModel(
      occupation: UserOccupation.valueForIndex(json.getInt('occupation')),
      gender: UserGender.valueForIndex(json.getInt('gender')),
      vip: json.getStringOrNull('vip'),
    );
  }
}
