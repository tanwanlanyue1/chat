import 'dart:async';
import 'dart:convert';

import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户信息缓存
class ChatUserInfoCache {
  static final instance = ChatUserInfoCache._();
  final _cache = <String, ChatUserInfo>{};
  final _streamController = StreamController<ChatUserInfo>.broadcast();

  ChatUserInfoCache._();

  factory ChatUserInfoCache() => instance;

  Future<ChatUserInfo> getOrQuery(
    String userId, {
    bool isQueryFromServer = false,
  }) async {
    var info = get(userId);
    if (info != null && !isQueryFromServer) {
      AppLogger.d('ChatUserInfoCache: hit cache: ${userId}');
      return info;
    }

    //从服务器获取
    if (isQueryFromServer) {
      final results = await ZIM.getInstance()?.queryUsersInfo(
        [userId.toString()],
        ZIMUserInfoQueryConfig()..isQueryFromServer = true,
      );
      info =
          results?.userList.firstOrNull?.let(ChatUserInfo.fromZIMUserFullInfo);
      if (info != null) {
        _cache[userId] = info;
        return info;
      }
    }

    //本地获取
    info = await ZIMKit()
        .queryUser(userId)
        .then<ChatUserInfo>(ChatUserInfo.fromZIMUserFullInfo);
    _cache[userId] = info;

    return info;
  }

  ChatUserInfo? get(String userId) {
    return _cache[userId];
  }

  ///用户信息流
  Stream<ChatUserInfo> get userInfoStream => _streamController.stream;

  ///通过用户Model更新IM用户信息
  void updateWithUserModel(UserModel userModel) {
    final userId = userModel.uid.toString();
    var oldUserInfo = get(userId);
    if(userModel.onlineStatus == null){
      userModel.onlineStatus == oldUserInfo?.onlineStatus;
    }
    final newUserInfo = ChatUserInfo.fromUserModel(userModel);
    if (newUserInfo != oldUserInfo) {
      _cache[userId] = newUserInfo;
      _streamController.add(newUserInfo);
    }
  }

  void delete(String userId) {
    _cache.remove(userId);
  }

  void clear() {
    _cache.clear();
  }
}

///聊天用户信息
class ChatUserInfo {
  ///用户ID
  final String id;

  ///昵称
  final String name;

  ///头像
  final String avatar;

  ///职业
  final UserOccupation occupation;

  ///性别
  final UserGender gender;

  ///VIP图标
  final String? vip;

  /// 在线状态 0在线 1登出 2离线
  final int? onlineStatus;

  ///数据更新时间戳
  int updatedAt = 0;

  ChatUserInfo({
    required this.id,
    required this.name,
    required this.avatar,
    this.occupation = UserOccupation.unknown,
    this.gender = UserGender.unknown,
    this.vip,
    this.onlineStatus,
    this.updatedAt = 0,
  });

  factory ChatUserInfo.fromZIMUserFullInfo(ZIMUserFullInfo info) {
    var json = {};
    final extendedData = info.extendedData;
    if (extendedData.isNotEmpty) {
      try {
        final data = jsonDecode(extendedData);
        if (data is Map) {
          json = data;
        }
      } catch (ex) {
        AppLogger.w(
            '解析ZIMUserFullInfo扩展数据失败, ex=$ex, extendedData=$extendedData');
      }
    }
    return ChatUserInfo(
      id: info.baseInfo.userID,
      name: info.baseInfo.userName,
      avatar: info.userAvatarUrl,
      occupation: UserOccupation.valueForIndex(json.getInt('occupation')),
      gender: UserGender.valueForIndex(json.getInt('gender')),
      vip: json.getStringOrNull('vip'),
      onlineStatus: json.getIntOrNull('onlineStatus'),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory ChatUserInfo.fromUserModel(UserModel info) {
    return ChatUserInfo(
      id: info.uid.toString(),
      name: info.nickname,
      avatar: info.avatar ?? '',
      occupation: info.occupation,
      gender: info.gender,
      vip: info.nameplate,
      onlineStatus: info.onlineStatus,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  ChatUserInfo copyWith({
    String? id,
    String? name,
    String? avatar,
    UserOccupation? occupation,
    UserGender? gender,
    String? vip,
    int? onlineStatus,
    int? updatedAt,
  }) {
    return ChatUserInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      occupation: occupation ?? this.occupation,
      gender: gender ?? this.gender,
      vip: vip ?? this.vip,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  //equatable
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatar == other.avatar &&
          occupation == other.occupation &&
          gender == other.gender &&
          vip == other.vip &&
          onlineStatus == other.onlineStatus;

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    return 'ChatUserInfo{id: $id, name: $name, avatar: $avatar, occupation: $occupation, gender: $gender, vip: $vip, onlineStatus: $onlineStatus}';
  }
}
