import 'package:get/get.dart';

class HomeState {
  List<AppBarItem> allBottomNavItems = [
    const AppBarItem(
      icon: 'assets/images/home/chat_none.png',
      activeIcon: 'assets/images/home/chat.png',
      title: '聊天',
    ),
    const AppBarItem(
      icon: 'assets/images/home/order_form_none.png',
      activeIcon: 'assets/images/home/order_form.png',
      title: '订单',
    ),
    const AppBarItem(
        icon: 'assets/images/home/dating_hall_none.png',
        activeIcon: 'assets/images/home/dating_hall.png',
        title: '交友大厅',
    ),
    const AppBarItem(
        icon: 'assets/images/home/discover_none.png',
        activeIcon: 'assets/images/home/discover.png',
        title: '发现',
    ),
    const AppBarItem(
        icon: 'assets/images/home/mine_none.png',
        activeIcon: 'assets/images/home/mine.png',
        title: '我的',
    ),
  ];
  //默认下标
  final initPage = 0.obs;

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
