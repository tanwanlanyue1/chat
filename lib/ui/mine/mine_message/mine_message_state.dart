import 'package:guanjia/common/routes/app_pages.dart';

class MineMessageState {
  MineMessageState() {
    ///Initialize variables
  }

  List<MineMessageOptions> options = [
    MineMessageOptions(
        icon: "assets/images/mine/message_fans.png",
        text: "粉丝",
        route: AppRoutes.mineFans,
        unread: 0),
    MineMessageOptions(
        icon: "assets/images/mine/message_comment.png",
        text: "评论回复",
        route: AppRoutes.mineComment),
    MineMessageOptions(
        icon: "assets/images/mine/message_praise.png",
        text: "赞",
        route: AppRoutes.minePraise),
  ];

  List<MessageItem> items = [
    MessageItem(
        icon: "assets/images/mine/message_system.png",
        title: "系统消息",
        detail: "",
        time: "12:20",
        unread: 0),
    MessageItem(
        icon: "assets/images/mine/message_notification.png",
        title: "通知公告",
        detail: "",
        time: "12:20",
        unread: 0),
  ];
}

class MineMessageOptions {
  final String icon;
  final String text;
  final String route;
  int unread;

  MineMessageOptions({
    required this.icon,
    required this.text,
    required this.route,
    this.unread = 0,
  });
}

class MessageItem {
  final String icon;
  final String title;
  String? detail;
  String? time;
  int unread;

  MessageItem({
    required this.icon,
    required this.title,
    this.detail,
    this.time,
    this.unread = 0,
  });
}
