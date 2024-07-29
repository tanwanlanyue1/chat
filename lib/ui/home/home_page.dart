import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/disambiguation_page.dart';
import 'package:guanjia/ui/home/widget/conversation_drawer.dart';
import 'package:guanjia/ui/mine/mine_page.dart';
import 'package:guanjia/ui/plaza/plaza_page.dart';
import 'package:guanjia/ui/wish_pavilion/wish_pavilion_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'home_controller.dart';
import 'widget/home_drawer_controller.dart';

class HomePage extends StatelessWidget {

  final controller = Get.put(HomeController());
  final state = Get.find<HomeController>().state;

  @override
  Widget build(BuildContext context) {
    return AppExitConfirm(
      child: Scaffold(
        body: HomeDrawerController(
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DisambiguationPage(),
              WishPavilionPage(),
              PlazaPage(),
              MinePage(),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavItem(),
        drawer: ConversationDrawer(),
      ),
    );
  }

  //底部
  Widget bottomNavItem(){
    return ObxValue((p0) => Container(
      padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
      color: AppColor.brown2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(state.allBottomNavItems.length, (i) {
          var item = state.allBottomNavItems[i];
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                if (i != state.initPage.value) {
                  controller.updateInfoList();
                }
                controller.setInitPage = i;
              },
              child: Container(
                height: 50.rpx,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Visibility(
                      visible: i == state.initPage.value,
                      child: AppImage.asset("assets/images/home/bottom_select.png",width: 60.rpx,height: 50.rpx,),
                    ),
                    Container(
                      width: 60.rpx,
                      padding: EdgeInsets.only(top: 5.rpx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppImage.asset(i == state.initPage.value ? item.icon : item.activeIcon,width: 22.rpx, height: 24.rpx,),
                          Text( item.title,style:  i == state.initPage.value ?
                          AppTextStyle.fs10b.copyWith(color: AppColor.red1):
                          AppTextStyle.fs10m.copyWith(color: AppColor.brown36),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ),state.initPage);
  }
}
