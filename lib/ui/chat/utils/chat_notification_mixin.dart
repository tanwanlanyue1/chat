part of 'chat_manager.dart';

///通知mixin
mixin _ChatNotificationMixin {
  static const _channelName = '新消息通知';
  static const _chatNotificationType = 1;

  ///会话对应的通知id
  final _conversationNotificationIds = <String, Set<int>>{};

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

  ///点击通知
  void _onTapNotification(NotificationResponse response) {
    try {
      final payloadStr = response.payload ?? '';
      if (payloadStr.isEmpty) {
        return;
      }
      final payload = NotificationPayload.fromJson(jsonDecode(payloadStr));
      if (payload.type == NotificationTypes.chatMessage) {
        final userId = int.tryParse('${payload.data}');
        if (userId != null) {
          ChatManager().startChat(userId: userId);
        }
      }
    } catch (ex) {
      AppLogger.d('_onTapNotification: $ex');
    }
  }

  ///新消息提醒通知
  void _onMessageArrivedNotification(List<ZIMMessage> messageList) {
    //是否需要提醒
    var reminder = false;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    const thresholdMs = 1 * 60 * 1000;
    for (var message in messageList) {
      //往外发的消息不弹通知
      if (message.direction == ZIMMessageDirection.send) {
        continue;
      }
      final kitMessage = message.toKIT();

      //音视频通话不弹通知，时间相差1分钟不弹
      if (![
        CustomMessageType.callInvite,
        CustomMessageType.callEnd,
        CustomMessageType.callReject,
      ].contains(kitMessage.customType) && (nowMs - message.timestamp <= thresholdMs)) {
        reminder = true;
        _showNotification(kitMessage);
      }
    }

    if (reminder) {
      if (SS.inAppMessage.bellReminderRx()) {
        FlutterRingtonePlayer().playNotification();
      }
      if (SS.inAppMessage.vibrationReminderRx()) {
        Vibration.vibrate();
      }
    }
  }

  ///显示通知
  void _showNotification(ZIMKitMessage message) async {
    //在聊天页不显示通知
    final route = AppPages.routeObserver.stack.firstOrNull;
    if (route?.settings.name == AppRoutes.messageListPage) {
      final registered = Get.isRegistered<MessageListController>(
          tag: message.info.conversationID);
      if (registered) {
        return;
      }
    }

    final notificationId = message.info.messageID.hashCode;
    final user = await ChatUserInfoCache().getOrQuery(message.zim.senderUserID);
    var nickname = user.baseInfo.userName;
    if (nickname.isEmpty) {
      nickname = user.baseInfo.userID;
    }
    final content = message.toPlainText();
    AndroidBitmap<Object>? largeIcon;
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
      nickname,
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
        iOS: DarwinNotificationDetails(),
      ),
      payload: NotificationPayload(
        type: NotificationTypes.chatMessage,
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
  final int type;

  ///数据
  final dynamic data;

  NotificationPayload({required this.type, this.data});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      NotificationPayload(
        type: json['type'] ?? 0,
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data,
      };

  String toJsonString() => jsonEncode(toJson());
}

///通知类型
class NotificationTypes {
  NotificationTypes._();

  ///聊天消息
  static const chatMessage = 1;
}
