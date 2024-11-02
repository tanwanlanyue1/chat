import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_message_controller.dart';
import 'mine_message_view.dart';

///我的-消息

class MineMessagePage extends StatelessWidget {
  final int tabIndex;

  const MineMessagePage({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MineMessagePageController(tabIndex: tabIndex),
      builder: (controller) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AppAssetImage('assets/images/mine/sys_msg_bg.jpg'),
              fit: BoxFit.fill,
            )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: buildAppBar(controller.tabController),
            body: Container(
              margin: FEdgeInsets(top: 4.rpx),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.rpx)),
                color: Colors.white,
              ),
              child: TabBarView(
                controller: controller.tabController,
                children: const [
                  MineMessageView(key: Key('sys_notice'), type: 6),
                  MineMessageView(key: Key('sys_message'), type: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(TabController? tabController){
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: TabBar(
        splashFactory: NoSplash.splashFactory,
        controller: tabController,
        labelStyle: AppTextStyle.fs18m,
        labelColor: AppColor.blackBlue,
        unselectedLabelStyle: AppTextStyle.fs16,
        unselectedLabelColor: AppColor.grayText,
        indicatorColor: Colors.transparent,
        indicatorWeight: 0.001,
        isScrollable: true,
        tabs: [
          Obx(() {
            var count =
                SS.inAppMessage.latestSysNoticeRx()?.systemCount ?? 0;
            if (tabIndex == 0) {
              count = 0;
            }
            return Tab(
                text: count > 0 ? '${S.current.systemAnnouncement}($count)' : S.current.systemAnnouncement,
                height: 40.rpx);
          }),
          Obx(() {
            var count =
                SS.inAppMessage.latestSysNoticeRx()?.userCount ?? 0;
            if (tabIndex == 1) {
              count = 0;
            }
            return Tab(
                text: count > 0 ? '${S.current.systemMessages}($count)' : S.current.systemMessages,
                height: 40.rpx);
          }),
        ],
      ),
    );
  }
}

class MineMessagePageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  MineMessagePageController({required int tabIndex}) {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: tabIndex,
    );
  }

  void setSelectedTabIndex(int index){
    tabController.index = index;
  }

}
