part of 'chat_manager.dart';

///通知mixin
mixin _ChatNotificationMixin {
  static const _channelName = '新消息通知';

  ///会话对应的通知id
  final _conversationNotificationIds = <String, Set<int>>{};
  var _isStartChatWithAppLaunched = false;

  ///初始化通知
  Future<void> _initNotification() async {
    if (Platform.isAndroid) {
      final androidPlugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      const channel = AndroidNotificationChannel(
        AppConfig.zegoChatResourceId,
        _channelName,
        description: _channelName,
        importance: Importance.max,
        enableVibration: false,
        showBadge: false,
        playSound: false,
      );
      await androidPlugin?.createNotificationChannel(channel);
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

  ///应用启动后跳转聊天页
  void _startChatWithAppLaunch() async {
    if (_isStartChatWithAppLaunched) {
      return;
    }
    _isStartChatWithAppLaunched = true;

    // payload: {"operation_type":"text_msg","id":"21","sender":{"id":"20","name":"Beauty"},"type":1},
    final options = await PluginUtil.getAppLaunchOptions();
    // FileLogger.d('details: ${jsonEncode(options)}');
    final payload = options['payload'];
    if (payload == null) {
      return;
    }
    try {
      final json = jsonDecode(payload);
      final sender = json['sender'];
      if (json['type'] != ZIMConversationType.peer.index || sender is! Map) {
        return;
      }
      final senderUid = int.tryParse("${sender['id']}");
      if (senderUid != null) {
        ChatManager().startChat(userId: senderUid);
      }
    } catch (ex) {
      AppLogger.w('startChatWithNotification ex=$ex');
    }
  }

  ///点击通知
  void _onTapNotification(NotificationResponse response) {
    try {
      final payloadStr = response.payload ?? '';
      if (payloadStr.isEmpty) {
        return;
      }
      final payload = NotificationPayload.fromJson(jsonDecode(payloadStr));
      switch (payload.type) {
        case NotificationType.sysNotice:
          Get.toNamed(AppRoutes.messageNotice);
          break;
        case NotificationType.chatMessage:
          final userId = int.tryParse('${payload.data}');
          if (userId != null) {
            ChatManager().startChat(userId: userId);
          }
          break;
      }
    } catch (ex) {
      AppLogger.d('_onTapNotification: $ex');
    }
  }

  ///显示通知
  void _showNotification(ZIMKitMessage message) async {
    //在聊天页不显示通知
    final route = AppPages.routeObserver.stack.firstOrNull;
    if (route?.settings.name == AppRoutes.messageListPage) {
      final registered = Get.isRegistered<MessageListController>(
          tag: message.info.conversationID);
      if (registered && Global().appStateRx() == AppLifecycleState.resumed) {
        return;
      }
    }

    final notificationId = message.info.messageID.hashCode;
    String title;
    String content;
    AndroidBitmap<Object>? largeIcon;
    final user =
    await ChatUserInfoCache().getOrQuery(message.zim.senderUserID);
    title = user.baseInfo.userName;
    if (title.isEmpty) {
      title = user.baseInfo.userID;
    }
    content = message.toPlainText() ?? '';
    try {
      final fileResp = DefaultCacheManager().getImageFile(user.userAvatarUrl);
      final resp = await fileResp.first.timeout(2.seconds);
      if (resp is FileInfo) {
        largeIcon = FilePathAndroidBitmap(resp.file.path);
      }
    } catch (ex) {
      AppLogger.w('发通知时，获取用户头像失败, $ex');
    }

    final conversationID = message.info.conversationID;
    await FlutterLocalNotificationsPlugin().show(
      notificationId,
      title,
      content,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConfig.zegoChatResourceId,
          _channelName,
          channelDescription: _channelName,
          priority: Priority.max,
          importance: Importance.max,
          visibility: NotificationVisibility.public,
          icon: 'logo',
          largeIcon: largeIcon,
          enableVibration: false,
          playSound: false,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: NotificationPayload(
        type: message.isSysNotice
            ? NotificationType.sysNotice
            : NotificationType.chatMessage,
        data: conversationID,
      ).toJsonString(),
    );

    _conversationNotificationIds
        .putIfAbsent(conversationID, () => <int>{})
        .add(notificationId);
  }

  ///清除通知
  ///- conversationId 会话id，如果不传，则清除所有通知
  Future<void> clearNotifications({String? conversationId}) async {
    if (conversationId != null) {
      final ids = _conversationNotificationIds[conversationId] ?? <int>{};
      for (var id in ids) {
        await FlutterLocalNotificationsPlugin().cancel(id);
      }
    } else {
      await FlutterLocalNotificationsPlugin().cancelAll();
    }
  }
}

///通知Payload
class NotificationPayload {
  ///类型
  final NotificationType type;

  ///数据
  final dynamic data;

  NotificationPayload({required this.type, this.data});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      NotificationPayload(
        type: NotificationType.values.asNameMap()[json['type'] ?? ''] ??
            NotificationType.chatMessage,
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'data': data,
      };

  String toJsonString() => jsonEncode(toJson());
}

///通知类型
enum NotificationType {
  ///系统公告
  sysNotice,

  ///聊天消息
  chatMessage;
}
