import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/network/api/model/im/chat_user_model.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/conversation_list/conversation_list_controller.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../../../common/network/api/api.dart';

///聊天用户信息数据
class ChatUserManager {
  ChatUserManager._();

  factory ChatUserManager() => instance;
  static final instance = ChatUserManager._();

  ///定时器时隔
  static const _kSyncDelay = Duration(minutes: 3);

  ///缓存有效期
  static const _kCacheTTL = 1000 * 1;

  ///分页大小
  static const _kPageSize = 50;

  final _cache = <String, ChatUserModel>{};
  final _streamController =
      StreamController<Map<String, ChatUserModel>>.broadcast();
  var _start = false;
  var _updatedAt = 0;
  Timer? _timer;

  ///监听用户信息变更
  Stream<Map<String, ChatUserModel>> get stream => _streamController.stream;

  ///开始同步数据
  void startSync() {
    _start = true;
    _timer?.cancel();
    final delayStart = _kSyncDelay.inMilliseconds + _updatedAt - DateTime.now().millisecondsSinceEpoch;
    if(delayStart <= 0){
      AppLogger.d('ChatUserManager: startSync');
      _sync();
    }else{
      AppLogger.d('ChatUserManager: startSync 等待${delayStart}ms');
      _timer = Timer(delayStart.milliseconds, _sync);
    }
  }

  ///同步数据
  Future<void> _sync() async {
    AppLogger.d('ChatUserManager: _sync ${DateTime.now().format}');
    _updatedAt = DateTime.now().millisecondsSinceEpoch;
    final userIds = Get.tryFind<ConversationListController>()
        ?.state
        .conversationListNotifier
        .value
        .map((e) => e.value.id)
        .where((element) {
      //不刷新缓存未超过有效期的用户信息
      final item = _cache[element];
      if (item != null && _updatedAt - item.createdAt < _kCacheTTL) {
        return false;
      }
      return true;
    }).toList();

    if (userIds == null || userIds.isEmpty) {
      return;
    }

    //分页查询数据
    final pageCount = (userIds.length / _kPageSize).ceil();
    for (var page = 0; page < pageCount; page++) {
      if (!_start) {
        return;
      }
      final updateMap = <String, ChatUserModel>{};
      final ids = userIds.skip(page * _kPageSize).take(_kPageSize).toList();
      final response = await IMApi.getChatUserList(ids);
      final users = response.data ?? [];

      for (var user in users) {
        if (_cache[user.uid] != user) {
          updateMap[user.uid] = user;
        }
      }
      if (updateMap.isNotEmpty) {
        _cache.addAll(updateMap);
        _streamController.add(updateMap);
      }
    }

    //延时同步
    if (_start) {
      _timer = Timer(_kSyncDelay, _sync);
    }
  }

  ///停止同步数据
  void stopSync() {
    AppLogger.d('ChatUserManager: stopSync');
    _start = false;
    _timer?.cancel();
    _timer = null;
  }

  Future<ChatUserModel> getOrQuery(
    String userId, {
    bool isQueryFromServer = false,
  }) async {
    var info = get(userId);
    if (info != null && !isQueryFromServer) {
      AppLogger.d('ChatUserManager: hit cache: ${userId}');
      return info;
    }

    //从服务器获取
    if (isQueryFromServer) {
      final response = await IMApi.getChatUserList([userId]);
      info = response.data?.firstOrNull;
      if (info != null && _cache[userId] != info) {
        _cache[userId] = info;
        return info;
      }
    }

    //本地获取
    info = await ZIMKit()
        .queryUser(userId)
        .then<ChatUserModel>((data) => data.toChatUserModel());
    _cache[userId] = info;

    return info;
  }

  ChatUserModel? get(String userId) {
    return _cache[userId];
  }

  ///通过用户Model更新IM用户信息
  void updateWithUserModels(List<UserModel> list) {
    batchUpdate(list.map((e) => e.toChatUserModel()).toList());
  }

  ///批量更新缓存
  void batchUpdate(List<ChatUserModel> list) {
    if(list.isEmpty){
      return;
    }
    final updateMap = <String, ChatUserModel>{};
    for (var item in list) {
      final oldUser = get(item.uid);
      if (item.onlineStatus == null) {
        item.onlineStatus == oldUser?.onlineStatus;
      }
      if (item != oldUser) {
        updateMap[item.uid] = item;
      }
    }
    if(updateMap.isNotEmpty){
      _cache.addAll(updateMap);
      _streamController.add(updateMap);
    }
  }

  ///释放资源，清理数据
  void dispose() {
    stopSync();
    _cache.clear();
  }
}

extension on ZIMUserFullInfo {
  ChatUserModel toChatUserModel() {
    var json = {};
    final extendedData = this.extendedData;
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
    return ChatUserModel(
      uid: baseInfo.userID,
      nickname: baseInfo.userName,
      avatar: userAvatarUrl,
      occupation: UserOccupation.valueForIndex(json.getInt('occupation')),
      gender: UserGender.valueForIndex(json.getInt('gender')),
      nameplate: json.getStringOrNull('vip') ?? '',
      onlineStatus: json.getIntOrNull('onlineStatus'),
      createdAt: json.getInt('updateTime'),
    );
  }
}

extension UserModelX on UserModel {
  ChatUserModel toChatUserModel() {
    return ChatUserModel(
      uid: uid.toString(),
      nickname: nickname,
      avatar: avatar ?? '',
      occupation: occupation,
      gender: gender,
      nameplate: nameplate,
      onlineStatus: onlineStatus,
      signature: signature,
    );
  }
}

extension ZIMKitConversationX on ZIMKitConversation {
  ChatUserModel toChatUserModel() {
    return ChatUserModel(
      uid: id,
      nickname: name,
      avatar: avatarUrl,
      occupation: UserOccupation.unknown,
      gender: null,
      nameplate: '',
      onlineStatus: null,
    );
  }
}
