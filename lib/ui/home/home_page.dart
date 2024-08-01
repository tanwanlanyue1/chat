import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/mine/mine_page.dart';
import 'package:guanjia/ui/plaza/plaza_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';
import '../mine/mine_page_bak.dart';
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
            Container(),
            Container(),
            Container(),
            PlazaPage(),
            MinePageBak(),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  //底部
  Widget buildBottomNavigationBar() {
    return Obx(() {
      return BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: controller.setCurrentPage,
        currentIndex: state.currentPageRx(),
        items: state.allBottomNavItems.map((item) {
          return BottomNavigationBarItem(
            icon: AppImage.asset(
              item.icon,
              width: 32.rpx,
              height: 32.rpx,
            ),
            activeIcon: AppImage.asset(
              item.activeIcon,
              width: 32.rpx,
              height: 32.rpx,
            ),
            label: item.title,
          );
        }).toList(growable: false),
      );
    });
  }
}
