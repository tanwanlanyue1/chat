import 'dart:async';
import 'dart:convert';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/ui/chat/chat_event_notifier.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/ui/mine/inapp_message/models/red_packet_update_content.dart';
import 'package:vibration/vibration.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///应用消息服务
class InAppMessageService extends GetxService {
  final _streamController = StreamController<InAppMessage>.broadcast();
  final _redPacketMessageContentCache = <int, RedPacketUpdateContent>{};

  final _appSettingPrefs = LocalStorage('AppSetting');
  static const _kVibrationReminder = 'vibrationReminder';
  static const _kBellReminder = 'bellReminder';

  ///振动提醒
  final vibrationReminderRx = false.obs;

  ///铃声提醒
  final bellReminderRx = false.obs;

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

    _init();
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
    if (message.type == InAppMessageType.redPacketUpdate) {
      message.redPacketUpdateContent?.let(_updateRedPacketMessageStatus);
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
}
