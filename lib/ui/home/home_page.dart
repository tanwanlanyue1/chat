import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/discover/discover_page.dart';
import 'package:guanjia/ui/chat/chat_page.dart';
import 'package:guanjia/ui/mine/mine_page.dart';
import 'package:guanjia/ui/order/order_page.dart';
import 'package:guanjia/ui/plaza/plaza_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';
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
            OrderPage(),
            PlazaPage(),
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
      return BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: controller.setCurrentPage,
        currentIndex: currentPage,
        selectedItemColor: AppColor.primaryBlue,
        unselectedItemColor: AppColor.tab,
        unselectedLabelStyle: AppTextStyle.fs12m,
        selectedLabelStyle: AppTextStyle.fs12m,
        items: state.allBottomNavItems.mapIndexed((index, item) {
          return BottomNavigationBarItem(
            icon: Badge(
              label: Text(chatUnreadText),
              backgroundColor: AppColor.red6,
              isLabelVisible: index == 0 && chatUnread > 0,
              child: AppImage.asset(
                item.icon,
                width: 28.rpx,
                height: 28.rpx,
                color: currentPage == index ? AppColor.primaryBlue : AppColor.tab,
              ),
            ),
            label: item.title,
          );
        }).toList(growable: false),
      );
    });
  }
}
