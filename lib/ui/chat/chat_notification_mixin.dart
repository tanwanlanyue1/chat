part of 'chat_manager.dart';

///通知mixin
mixin ChatNotification {
  static const _channelId = 'guajia_chat';
  static const _channelName = 'guajia_chat_notification';
  static const _channelDesc = 'guajia app chat channel';
  static const _chatNotificationType = 1;

  ///会话对应的通知id
  final _conversationNotificationIds = <String, Set<int>>{};

  ///初始化通知
  Future<void> _initNotification() async {
    if (Platform.isAndroid) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
        enableVibration: true,
        showBadge: false,
        playSound: true,
      );
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
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
    try{
      final payloadStr = response.payload ?? '';
      if(payloadStr.isEmpty){
        return;
      }
      final payload = NotificationPayload.fromJson(jsonDecode(payloadStr));
      if(payload.type == NotificationTypes.chatMessage){
        final userId = int.tryParse('${payload.data}');
        if(userId != null){
          ChatManager().startChat(userId: userId);
        }
      }
    }catch(ex){
      AppLogger.d('_onTapNotification: $ex');
    }
  }

  ///新消息提醒通知
  void _onMessageArrivedNotification(List<ZIMMessage> messageList) {
    //是否需要提醒
    var reminder = false;
    for (var message in messageList) {
      //往外发的消息不弹通知
      if (message.direction == ZIMMessageDirection.send) {
        continue;
      }
      final kitMessage = message.toKIT();

      //音视频通话不弹通知
      if (kitMessage.customType != CustomMessageType.callEnd) {
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
    // if(Global().appStateRx() == AppLifecycleState.resumed){
    //   AppLogger.d('应用后台，');
    //   return;
    // }

    //在聊天页不显示通知
    final notificationId = message.info.messageID.hashCode;
    AppLogger.d('_showNotification: ${message.toPlainText()}');
    final conversationID = message.info.conversationID;
    //TODO 可以做一下内存缓存
    final user = await ZIMKit().queryUser(message.zim.senderUserID);
    var nickname = user.baseInfo.userName;
    if (nickname.isEmpty) {
      nickname = user.baseInfo.userID;
    }
    final content = message.toPlainText();

    await FlutterLocalNotificationsPlugin().show(
      notificationId,
      nickname,
      content,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          priority: Priority.high,
          importance: Importance.high,
          visibility: NotificationVisibility.public,
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
