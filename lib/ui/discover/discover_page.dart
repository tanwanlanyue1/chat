import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
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
  DiscoverPage({Key? key}) : super(key: key);

  final controller = Get.put(DiscoverController());
  final state = Get.find<DiscoverController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: TabBar(
          splashFactory: NoSplash.splashFactory,
          controller: controller.tabController,
          labelStyle: AppTextStyle.fs20b.copyWith(fontWeight: FontWeight.w900),
          labelColor: AppColor.blackBlue,
          unselectedLabelStyle:
          AppTextStyle.fs16m.copyWith(fontWeight: FontWeight.w500),
          unselectedLabelColor: AppColor.grayText,
          isScrollable: true,
          labelPadding: FEdgeInsets.zero,
          indicatorPadding: FEdgeInsets(bottom: 4.rpx),
          indicator: TabUnderlineIndicator(
            width: 20.rpx,
            widthEqualTitle: false,
            gradient: LinearGradient(
              colors: AppColor.horizontalGradient.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderSide: BorderSide(width: 4.rpx),
          ),
          onTap: (val){
            state.titleIndex.value = val;
          },
          tabs: [
            Container(
              margin: EdgeInsets.only(right: 20.rpx),
              child: Tab(text: S.current.dating, height: 40.rpx),
            ),
            Tab(text: S.current.hotActivity, height: 40.rpx),
          ],
        ),
        actions: [
          Obx(() => Visibility(
            visible: state.titleIndex.value == 0 && SS.login.userType.isUser,
            child: Container(
              width: 80.rpx,
              alignment: Alignment.center,
              child: CommonGradientButton(
                text: S.current.releaseInvitation,
                height: 32.rpx,
                textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
                onTap: controller.onTapInvitation,
                borderRadius: BorderRadius.circular(16.rpx),
              ),
            ),
          ))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xffF6E5FF),
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.center
            )
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            FriendDatePage(),
            ActivityPage(),
          ],
        ),
      ),
    );
  }

}
