import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/discover/friend_date/friend_date_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'activity/activity_page.dart';
import 'discover_controller.dart';

///发现-首页
class DiscoverPage extends StatelessWidget {
  DiscoverPage({super.key});

  final controller = Get.put(DiscoverController());
  final state = Get.find<DiscoverController>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AppAssetImage(
                "assets/images/common/back_color_img.png",
              ),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          systemOverlayStyle: SystemUI.lightStyle,
          title: TabBar(
            splashFactory: NoSplash.splashFactory,
            controller: controller.tabController,
            labelStyle: AppTextStyle.fs22b,
            labelColor: Colors.white,
            unselectedLabelStyle: AppTextStyle.fs16,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            isScrollable: true,
            labelPadding: FEdgeInsets.zero,
            indicator: const BoxDecoration(),
            overlayColor: MaterialStateProperty.resolveWith((states) {
              return Colors.transparent;
            }),
            onTap: (val){
              state.titleIndex.value = val;
            },
            tabs: [
              Tab(text: S.current.dating, height: 44.rpx),
              Container(
                margin: EdgeInsets.only(right: 20.rpx,left: 20.rpx),
                child: Tab(text: S.current.hotActivity, height: 44.rpx),
              ),
            ],
          ),
          actions: [
            Obx(() => Visibility(
              visible: state.titleIndex.value == 0 && SS.login.userType.isUser,
              child: GestureDetector(
                onTap: controller.onTapInvitation,
                child: Container(
                  margin: EdgeInsets.only(right: 16.rpx),
                  child: AppImage.asset(
                    "assets/images/discover/publish.png",
                    width: 80.rpx,
                    height: 32.rpx,
                  ),
                ),
              ),
            ))
          ],
        ),
        body: TabBarView(
          controller: controller.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FriendDatePage(),
            ActivityPage(),
          ],
        ),
      ),
    );
  }

}
