import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/ui/chat/chat_page.dart';
import 'package:guanjia/ui/discover/discover_page.dart';
import 'package:guanjia/ui/mine/mine_page.dart';
import 'package:guanjia/ui/order/order_page.dart';
import 'package:guanjia/ui/plaza/plaza_page.dart';
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
      final chatUnreadText = chatUnread > 100 ? '+99' : chatUnread.toString();
      return AppNavigationBar(
        onTap: controller.setCurrentPage,
        currentIndex: currentPage,
        items: state.allBottomNavItems,
        iconBuilder: (item, child){
          return Badge(
            label: Text(chatUnreadText),
            backgroundColor: AppColor.red6,
            isLabelVisible: item == state.allBottomNavItems.first  && chatUnread > 0,
            child: child,
          );
        },
      );
    });
  }
}
