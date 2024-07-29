import 'package:get/get.dart';

class HomeState {
  List<AppBarItem> allBottomNavItems = [
    const AppBarItem(
      icon: 'assets/images/home/disabuse.png',
      activeIcon: 'assets/images/home/disabuse_unselected.png',
      title: '解疑',
    ),
    const AppBarItem(
        icon: 'assets/images/home/wish.png',
        activeIcon: 'assets/images/home/wish_unselected.png',
        title: '心愿阁',
    ),
    const AppBarItem(
        icon: 'assets/images/home/plaza.png',
        activeIcon: 'assets/images/home/plaza_unselected.png',
        title: '广场',
    ),
    const AppBarItem(
        icon: 'assets/images/home/mine.png',
        activeIcon: 'assets/images/home/mine_unselected.png',
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
