import 'package:get/get.dart';

class HomeState {
  List<AppBarItem> allBottomNavItems = [
    const AppBarItem(
      icon: 'assets/images/home/tab_chat.png',
      activeIcon: 'assets/images/home/tab_chat_active.png',
      title: '聊天',
    ),
    const AppBarItem(
      icon: 'assets/images/home/tab_order.png',
      activeIcon: 'assets/images/home/tab_order_active.png',
      title: '订单',
    ),
    const AppBarItem(
        icon: 'assets/images/home/tab_community.png',
        activeIcon: 'assets/images/home/tab_community_active.png',
        title: '交友大厅',
    ),
    const AppBarItem(
        icon: 'assets/images/home/tab_discovery.png',
        activeIcon: 'assets/images/home/tab_discovery_active.png',
        title: '发现',
    ),
    const AppBarItem(
        icon: 'assets/images/home/tab_mine.png',
        activeIcon: 'assets/images/home/tab_mine_active.png',
        title: '我的',
    ),
  ];

  ///默认下标
  final currentPageRx = 0.obs;

  ///聊天消息未读数
  final messageUnreadRx = 0.obs;

}

class AppBarItem {

  ///未选中图标
  final String icon;

  ///已选中图标
  final String activeIcon;

  ///标题
  final String title;

  const AppBarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
  });

  AppBarItem copyWith({
    String? icon,
    String? activeIcon,
    String? title,
  }) {
    return AppBarItem(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      title: title ?? this.title,
    );
  }
}
