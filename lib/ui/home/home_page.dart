import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/chat_page.dart';
import 'package:guanjia/ui/discover/discover_page.dart';
import 'package:guanjia/ui/mine/mine_page.dart';
import 'package:guanjia/ui/order/order_page.dart';
import 'package:guanjia/ui/plaza/plaza_page.dart';
import 'package:guanjia/widgets/unread_badge.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'app_navigation_bar.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final state = Get.find<HomeController>().state;

  @override
  Widget build(BuildContext context) {
    return AppExitConfirm(
      child: Scaffold(
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const ChatPage(),
            const OrderPage(),
            const PlazaPage(),
            DiscoverPage(),
            const MinePage(),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  //底部
  Widget buildBottomNavigationBar() {
    return Obx(() {
      final currentPage = state.currentPageRx();
      final chatUnread = state.messageUnreadRx();
      return AppNavigationBar(
        onTap: controller.setCurrentPage,
        currentIndex: currentPage,
        items: state.allBottomNavItems,
        iconBuilder: (item, index, child) {
          if (item == state.allBottomNavItems.first && chatUnread > 0) {
            final begin = Offset(18.rpx, -2.rpx);
            final end = Offset(18.rpx, -10.rpx);
            final tween = currentPage == index
                ? Tween(begin: begin, end: end)
                : Tween(begin: end, end: begin);
            return TweenAnimationBuilder<Offset>(
              tween: tween,
              duration: const Duration(milliseconds: 300),
              child: child,
              builder: (_, offset, child) {
                return TabUnreadBadge(
                  unread: chatUnread,
                  offset: offset,
                  child: child ?? Spacing.blank,
                );
              },
            );
          }
          return child;
        },
      );
    });
  }
}
