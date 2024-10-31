import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

class HomeState {
  List<AppBarItem> allBottomNavItems = [
    AppBarItem(
      icon: 'assets/images/home/tab_chat.png',
      activeIcon: 'assets/images/home/tab_chat.json',
      title: S.current.chat,
    ),
    AppBarItem(
      icon: 'assets/images/home/tab_order.png',
      activeIcon: 'assets/images/home/tab_order.json',
      title: S.current.order,
    ),
    AppBarItem(
        icon: 'assets/images/home/tab_community.png',
        activeIcon: 'assets/images/home/tab_community.json',
        title: S.current.datingHall,
    ),
    AppBarItem(
        icon: 'assets/images/home/tab_discovery.png',
        activeIcon: 'assets/images/home/tab_discovery.json',
        title: S.current.discover,
    ),
    AppBarItem(
        icon: 'assets/images/home/tab_mine.png',
        activeIcon: 'assets/images/home/tab_mine.json',
        title: S.current.mine,
    ),
  ];

  ///默认下标
  final currentPageRx = 2.obs;

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
