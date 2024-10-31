import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
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
  static const _kSyncDelay = Duration(seconds: 5);
  final _cache = <String, ChatUserModel>{};
  final _streamController =
      StreamController<Map<String, ChatUserModel>>.broadcast();
  var _start = false;
  Timer? _timer;
  final _debounce = Debouncer(delay: 500.milliseconds);

  Stream<Map<String, ChatUserModel>> get stream => _streamController.stream;

  ///开始同步数据
  void startSync() {
    _debounce(() {
      _start = true;
      _timer?.cancel();
      _sync();
    });
  }

  ///同步数据
  Future<void> _sync() async {
    final userIds = Get.tryFind<ConversationListController>()
        ?.state
        .conversationListNotifier
        .value
        .map((e) => e.value.id)
        .toList();

    if (userIds != null && userIds.isNotEmpty) {
      final response = await IMApi.getChatUserList(userIds);
      final users = response.data ?? [];
      final updateMap = <String, ChatUserModel>{};
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
  void updateWithUserModel(UserModel userModel) {
    final userId = userModel.uid.toString();
    var oldUserInfo = get(userId);
    if (userModel.onlineStatus == null) {
      userModel.onlineStatus == oldUserInfo?.onlineStatus;
    }
    final newUserInfo = userModel.toChatUserModel();
    if (newUserInfo != oldUserInfo) {
      _cache[userId] = newUserInfo;
      _streamController.add({userId: newUserInfo});
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

extension on UserModel {
  ChatUserModel toChatUserModel() {
    return ChatUserModel(
      uid: uid.toString(),
      nickname: nickname,
      avatar: avatar ?? '',
      occupation: occupation,
      gender: gender,
      nameplate: nameplate,
      onlineStatus: onlineStatus,
    );
  }
}

extension ZIMKitConversationX on ZIMKitConversation{
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
