import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/notification/payload/app_update_payload.dart';
import 'package:guanjia/common/notification/payload/chat_message_payload.dart';
import 'package:guanjia/common/notification/payload/sys_notice_payload.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/file_logger.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/main.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/mine/mine_message/mine_message_page.dart';
import 'package:guanjia/ui/mine/mine_setting/app_update/app_update_manager.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../utils/app_logger.dart';
import '../utils/plugin_util.dart';

///应用通知
class NotificationManager {
  NotificationManager._();

  static NotificationChannel get chatChannel => NotificationChannel(
        id: AppConfig.zegoChatResourceId,
        name: S.current.newMessageNotification,
      );

  static NotificationChannel get callChannel => NotificationChannel(
        id: AppConfig.zegoCallResourceId,
        name: S.current.audioCallInvitationNotification,
      );

  static NotificationChannel get appUpdateChannel => NotificationChannel(
        id: 'guanjia_update',
        name: S.current.appUpdateNotification,
      );

  static final instance = NotificationManager._();

  factory NotificationManager() => instance;

  var _jumpWithAppLaunchOptions = '';

  /// A notification action which triggers a url launch event
  final String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  final String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  final String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  final String darwinNotificationCategoryPlain = 'plainCategory';

  DarwinInitializationSettings get _iOSSettings {
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    return DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // notificationCategories: darwinNotificationCategories,
    );
  }

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
    await FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('logo'),
        iOS: _iOSSettings,
      ),
      onDidReceiveNotificationResponse: _onTapNotification,
      //TODO 不会回调到，不知道是什么原因，因此使用ZegoPluginAdapter().signalingPlugin来监听通知点击了
      // onDidReceiveBackgroundNotificationResponse: _onTapNotification,
    );

    //仅处理iOS，Android已通过监听应用切换前台事件获取启动参数实现
    if (Platform.isIOS) {
      final signalingPlugin =
          ZegoPluginAdapter().signalingPlugin ?? ChatManager().signalingPlugin;
      signalingPlugin.getNotificationClickedEventStream().listen((event) {
        // FileLogger.d('getNotificationClickedEventStream: ${event.toString()}');
        ChatManager().updateInitTimestamp();
        ChatManager().startChatWithRemoteNotification(event.extras);
      });
    }
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
      enableVibration: false,
      showBadge: false,
      playSound: false,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  ///点击通知
  void _onTapNotification(NotificationResponse response) {
    print('_onTapNotification: ${response.payload}');
    FileLogger.d('_onTapNotification: ${response.payload}');
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
      if (_jumpMyMessage(json)) {
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
  bool _jumpChat(Map<String, dynamic> json) {
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

  ///跳转我的消息通知
  bool _jumpMyMessage(Map<String, dynamic> json) {
    final payload = SysNoticePayload.fromJson(json);
    if (payload != null) {
      final tabIndex = payload.type == 1 ? 1 : 0;
      final controller = Get.tryFind<MineMessagePageController>();
      AppLogger.d('_jumpMyMessage: $controller,  tabIndex:$tabIndex');
      if (controller != null) {
        controller.setSelectedTabIndex(tabIndex);
      }
      Get.toNamed(AppRoutes.mineMessage, arguments: {
        'tabIndex': tabIndex,
      });
      return true;
    }
    return false;
  }

  ///跳转app更新
  bool _jumpAppUpdate(Map<String, dynamic> json) {
    final appUpdatePayload = AppUpdatePayload.fromJson(json);
    if (appUpdatePayload == null) {
      return false;
    }
    if (appUpdatePayload.progress == 1 &&
        appUpdatePayload.apkFilePath.isNotEmpty) {
      AppUpdateManager.instance.installApk(appUpdatePayload.apkFilePath);
    }
    return true;
  }

  ///点击系统通知启动APP后跳转
  void jumpWithAppLaunch() async {
    try {
      final options = await PluginUtil.getAppLaunchOptions();
      AppLogger.d('jumpWithAppLaunch details: ${jsonEncode(options)}');
      final opts = jsonEncode(options);
      if (_jumpWithAppLaunchOptions == opts) {
        return;
      }
      _jumpWithAppLaunchOptions = opts;

      final payloadStr = options.getString('payload');
      final json = jsonDecode(payloadStr);
      if (json == null) {
        return;
      }
      _jumpMyMessage(json);
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
