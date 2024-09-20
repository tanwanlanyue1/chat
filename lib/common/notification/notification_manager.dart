import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/notification/payload/app_update_payload.dart';
import 'package:guanjia/common/notification/payload/chat_message_payload.dart';
import 'package:guanjia/common/notification/payload/sys_notice_payload.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/mine/mine_setting/app_update/app_update_manager.dart';

import '../utils/app_link.dart';
import '../utils/app_logger.dart';
import '../utils/plugin_util.dart';

///应用通知
class NotificationManager {
  NotificationManager._();

  static NotificationChannel get chatChannel => const NotificationChannel(
        id: AppConfig.zegoChatResourceId,
        name: '新消息通知',
      );

  static NotificationChannel get callChannel => const NotificationChannel(
        id: AppConfig.zegoCallResourceId,
        name: '音视频通话邀请通知',
      );

  static NotificationChannel get appUpdateChannel => const NotificationChannel(
        id: 'guanjia_update',
        name: '应用更新通知',
      );

  static final instance = NotificationManager._();

  factory NotificationManager() => instance;

  var _jumpWithAppLaunchPayload = '';

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('logo'),
        iOS: DarwinInitializationSettings(
            // requestSoundPermission: true,
            // requestBadgePermission: false,
            // requestAlertPermission: false,
            ),
      ),
      onDidReceiveNotificationResponse: _onTapNotification,
      onDidReceiveBackgroundNotificationResponse: _onTapNotification,
    );
  }

  ///创建通知渠道
  Future<void> _createNotificationChannel() async {
    final androidPlugin = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    //通知权限申请
    await androidPlugin?.requestNotificationsPermission();

    //创建聊天通知渠道
    var channel = AndroidNotificationChannel(
      chatChannel.id,
      chatChannel.name,
      description: chatChannel.name,
      importance: Importance.max,
      enableVibration: false,
      showBadge: false,
      playSound: false,
    );
    await androidPlugin?.createNotificationChannel(channel);

    //创建音视频通话渠道
    channel = AndroidNotificationChannel(
      callChannel.id,
      callChannel.name,
      description: callChannel.name,
      importance: Importance.max,
      enableVibration: true,
      showBadge: false,
      playSound: true,
    );
    await androidPlugin?.createNotificationChannel(channel);

    //创建应用下载进度通知渠道
    channel = AndroidNotificationChannel(
      appUpdateChannel.id,
      appUpdateChannel.name,
      description: appUpdateChannel.name,
      importance: Importance.max,
      enableVibration: false,
      showBadge: false,
      playSound: false,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  ///点击通知
  void _onTapNotification(NotificationResponse response) {
    try {
      final json = jsonDecode(response.payload ?? '');
      if (json == null) {
        return;
      }
      //点击聊天通知
      if (_jumpChat(json)) {
        return;
      }
      //点击系统消息通知
      if (_jumpSysNotice(json)) {
        return;
      }

      //点击应用更新下载通知
      if (_jumpAppUpdate(json)) {
        return;
      }
    } catch (ex) {
      AppLogger.d('_onTapNotification: $ex');
    }
  }

  ///跳转聊天
  bool _jumpChat(Map<String, dynamic> json){
    final payload = ChatMessagePayload.fromJson(json);
    if (payload != null) {
      final userId = int.tryParse(payload.conversationId);
      if (userId != null) {
        ChatManager().startChat(userId: userId);
      }
      return true;
    }
    return false;
  }

  ///跳转系统消息通知
  bool _jumpSysNotice(Map<String, dynamic> json){
    final payload = SysNoticePayload.fromJson(json);
    if (payload != null) {
      final link = payload.link;
      if (link == null) {
        return true;
      }
      if ([1, 2].contains(payload.jumpType)) {
        AppLink.jump(link, args: payload.extraJson);
      }
      return true;
    }
    return false;
  }

  ///跳转app更新
  bool _jumpAppUpdate(Map<String, dynamic> json){
    final appUpdatePayload = AppUpdatePayload.fromJson(json);
    if (appUpdatePayload == null) {
      return false;
    }
    if(appUpdatePayload.progress == 1 && appUpdatePayload.apkFilePath.isNotEmpty){
      AppUpdateManager.instance.installApk(appUpdatePayload.apkFilePath);
    }
    return true;
  }

  ///点击系统通知启动APP后跳转
  void jumpWithAppLaunch() async {
    try {
      final options = await PluginUtil.getAppLaunchOptions();
      AppLogger.d('jumpWithAppLaunch details: ${jsonEncode(options)}');
      final payloadStr = options.getString('payload');
      if (_jumpWithAppLaunchPayload == payloadStr) {
        return;
      }
      _jumpWithAppLaunchPayload = payloadStr;
      final json = jsonDecode(payloadStr);
      if (json == null) {
        return;
      }
      _jumpSysNotice(json);
    } catch (ex) {
      AppLogger.w('jumpWithAppLaunch ex=$ex');
    }
  }

}

///通知渠道
class NotificationChannel {
  final String id;
  final String name;

  const NotificationChannel({
    required this.id,
    required this.name,
  });
}
