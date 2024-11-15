part of 'chat_manager.dart';

///通知mixin
mixin _ChatNotificationMixin {

  ///会话对应的通知id
  final _conversationNotificationIds = <String, Set<int>>{};
  var _isStartChatWithAppLaunched = false;


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
    await ChatUserManager().getOrQuery(message.zim.senderUserID);
    title = user.nickname;
    if (title.isEmpty) {
      title = user.uid;
    }
    content = message.toPlainText() ?? '';
    try {
      final fileResp = DefaultCacheManager().getImageFile(user.avatar);
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
          NotificationManager.chatChannel.id,
          NotificationManager.chatChannel.name,
          channelDescription: NotificationManager.chatChannel.name,
          priority: Priority.max,
          importance: Importance.max,
          visibility: NotificationVisibility.public,
          icon: 'logo',
          largeIcon: largeIcon,
          enableVibration: false,
          playSound: false,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: false,
        ),
      ),
      payload: ChatMessagePayload(conversationId: conversationID).toJsonString(),
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

