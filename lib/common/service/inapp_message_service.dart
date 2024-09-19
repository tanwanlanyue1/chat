import 'dart:async';
import 'dart:convert';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/file_logger.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/plugin_util.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/ui/chat/utils/chat_event_notifier.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/ui/mine/inapp_message/models/red_packet_update_content.dart';
import 'package:vibration/vibration.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../network/api/model/user/message_unread_model.dart';

///应用消息服务
class InAppMessageService extends GetxService {
  final _streamController = StreamController<InAppMessage>.broadcast();
  final _redPacketMessageContentCache = <int, RedPacketUpdateContent>{};

  final _appSettingPrefs = LocalStorage('AppSetting');
  static const _kVibrationReminder = 'vibrationReminder';
  static const _kBellReminder = 'bellReminder';
  static const _kLatestSysNotice = 'latestSysNotice';
  static const _kLatestSysNoticeId = 'latestSysNoticeId';

  ///振动提醒
  final vibrationReminderRx = false.obs;

  ///铃声提醒
  final bellReminderRx = false.obs;

  ///最新一条系统通知
  final latestSysNoticeRx = Rxn<MessageUnreadModel>();

  final _debounce = Debouncer(delay: const Duration(milliseconds: 200));

  var _startWithAppLaunchUUid = '';

  @override
  void onInit() {
    super.onInit();

    //监听信令消息
    ChatEventNotifier().onReceiveCommandMessage.listen((event) {
      for (var message in event.messageList) {
        if (message is ZIMCommandMessage) {
          _onReceiveCommandMessage(message);
        }
      }
    });

    //监听系统消息(全员推送)
    ChatEventNotifier().onBroadcastMessageStream.listen((event) {
      if (event.type == ZIMMessageType.custom &&
          event.senderUserID == AppConfig.sysUserId) {
        _fetchLatestSysNotice();
      }
    });

    _init();
    _initSysNotice();
    SS.login.loginListen((isLogin) => _initSysNotice());
  }

  void _init() async {
    vibrationReminderRx.value =
        await _appSettingPrefs.getBool(_kVibrationReminder) ?? true;
    bellReminderRx.value =
        await _appSettingPrefs.getBool(_kBellReminder) ?? true;
    everAll([vibrationReminderRx, bellReminderRx], (_) {
      _appSettingPrefs.setBool(_kVibrationReminder, vibrationReminderRx.value);
      _appSettingPrefs.setBool(_kBellReminder, bellReminderRx.value);
    });
  }

  ///初始化系统通知
  void _initSysNotice() async {
    final userId = SS.login.userId;
    if (userId != null) {
      final key = _kLatestSysNotice + userId.toString();
      final json = await _appSettingPrefs.getJson(key);
      if (json != null) {
        latestSysNoticeRx.value = MessageUnreadModel.fromJson(json);
      }
      ever(latestSysNoticeRx, (value) {
        if (value == null) {
          _appSettingPrefs.remove(key);
        } else {
          _appSettingPrefs.setJson(key, value.toJson());
        }
      });
      _fetchLatestSysNotice();
    } else {
      latestSysNoticeRx.value = null;
    }
  }

  ///接收到自定义信令
  void _onReceiveCommandMessage(ZIMCommandMessage message) {
    final content = utf8.decode(message.message);
    print('onReceiveCommandMessage====${content}');
    if (content.isEmpty) {
      return;
    }
    try {
      final json = jsonDecode(content);
      if (json == null) {
        AppLogger.w('_onReceiveCommandMessage: json is null');
        return;
      }
      final message = InAppMessage.fromJson(json);
      if (message != null) {
        _streamController.add(message);
        _onReceiveInAppMessage(message);
      }
    } catch (ex) {
      AppLogger.w('_onReceiveCommandMessage: $ex');
    }
  }

  ///接收到应用内消息
  void _onReceiveInAppMessage(InAppMessage message) {
    switch (message.type) {
      case InAppMessageType.redPacketUpdate:
        message.redPacketUpdateContent?.let(_updateRedPacketMessageStatus);
      case InAppMessageType.sysMessage:
        _fetchLatestSysNotice();
      default:
        break;
    }
  }

  ///消息提醒
  void messageReminder() {
    //声音震动提醒
    if (SS.inAppMessage.bellReminderRx()) {
      FlutterRingtonePlayer().playNotification();
    }
    if (SS.inAppMessage.vibrationReminderRx()) {
      Vibration.vibrate();
    }
  }

  ///获取最新一条消息和未读数
  void _fetchLatestSysNotice() {
    _debounce(() async {
      final lastId = await _appSettingPrefs.getInt(_kLatestSysNoticeId);
      final response = await UserApi.getMessageUnread(lastId: lastId);
      if (response.isSuccess) {
        latestSysNoticeRx.value = response.data;
      }
    });
  }

  ///标记系统公告已读
  ///- lastId 最新一条通知id
  void markReadSysNotice(int lastId) {
    final notice = latestSysNoticeRx();
    if (notice != null) {
      latestSysNoticeRx.value = notice.copyWith(systemCount: 0);
      _appSettingPrefs.setInt(_kLatestSysNoticeId, lastId);
    }
  }

  ///标记系统消息已读
  void markReadSysMsg() {
    final notice = latestSysNoticeRx();
    if (notice != null) {
      latestSysNoticeRx.value = notice.copyWith(userCount: 0);
    }
  }

  ///更新红包消息状态
  void _updateRedPacketMessageStatus(RedPacketUpdateContent content) async {
    AppLogger.d('_updateRedPacketMessageStatus: $content');

    final conversationId =
        SS.login.userId == content.fromUid ? content.toUid : content.fromUid;

    //查询红包消息
    final config = ZIMMessageSearchConfig();
    config.startTime = content.createTime;
    config.endTime = config.startTime + 3000;
    config.subMessageTypes = [CustomMessageType.redPacket.value];
    config.senderUserIDs = [content.fromUid.toString()];
    config.count = 1;

    final results = await ZIM.getInstance()?.searchLocalMessages(
          conversationId.toString(),
          ZIMConversationType.peer,
          config,
        );
    print('更新红包消息状态: ${results?.messageList.length}');
    results?.messageList.forEach((element) {
      print(
          '更新红包消息状态 element:${(element as ZIMCustomMessage).message}  timestamp=${element.timestamp}');
    });
    final message = results?.messageList.firstOrNull;
    if (message != null && message.messageID == content.msgId) {
      final receiveTime =
          content.receiveTime?.let(DateTime.fromMillisecondsSinceEpoch);
      message.toKIT().setRedPacketLocal(
            MessageRedPacketLocal(
              status: content.status,
              receiveTime: receiveTime,
            ),
          );
    }

    _redPacketMessageContentCache[content.msgId] = content;
    EventBus().emit(kEventRedPacketUpdate, content);
  }

  RedPacketUpdateContent? removeRedPacketUpdateContent(int messageId) {
    return _redPacketMessageContentCache.remove(messageId);
  }

  ///监听应用内消息
  StreamSubscription<InAppMessage> listen(
      void Function(InAppMessage message)? onData) {
    return _streamController.stream.listen(onData);
  }

  ///应用通知栏启动APP跳转
  void startWithAppLaunch() async {
    //jumpType 跳转类型（0无 1外链, 2内页）
    //link 跳转链接
    //extraJson 扩展字段json
    // payload: {"jumpType": 1, "link":"/user/login","extraJson":""},
    final options = await PluginUtil.getAppLaunchOptions();
    AppLogger.d('startWithAppLaunch details: ${jsonEncode(options)}');
    final payload = options['payload'] as String?;
    if (payload == null) {
      return;
    }
    try {
      final uuid = payload.md5String;
      if (_startWithAppLaunchUUid == uuid) {
        return;
      }
      _startWithAppLaunchUUid = uuid;
      final payloadObj = _Payload.fromJson(jsonDecode(payload));
      final link = payloadObj.link;
      if (link == null) {
        return;
      }
      if ([1,2].contains(payloadObj.jumpType)) {
        AppLink.jump(link, args: payloadObj.extraJson);
      }
    } catch (ex) {
      AppLogger.w('startWithAppLaunch ex=$ex');
    }
  }
}

class _Payload {
  final int? jumpType;
  final String? link;
  final Map<String, dynamic>? extraJson;

  _Payload(this.jumpType, this.link, this.extraJson);

  factory _Payload.fromJson(Map<String, dynamic> json) {
    Map? extraMap;
    final extraJson = json['extraJson'];
    if (extraJson is String) {
      try {
        extraMap = jsonDecode(extraJson);
        final extra = extraMap?.getStringOrNull('extra');
        if(extra != null){
          extra.toJson()?.let((value){
            extraMap?.remove('extra');
            extraMap?.addAll(value);
          });
        }
      } catch (ex) {
        AppLogger.w('_Payload.fromJson > extraJson ex=$ex');
      }
    }
    return _Payload(
      json['jumpType'],
      json['link'],
      extraMap?.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
}
