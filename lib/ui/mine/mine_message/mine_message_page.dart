import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
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
        return Scaffold(
          backgroundColor: AppColor.grayBackground,
          appBar: AppBar(
            title: Text(S.current.myMessage),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            bottom: TabBar(
              controller: controller.tabController,
              labelStyle: AppTextStyle.fs14m,
              labelColor: AppColor.primaryBlue,
              unselectedLabelColor: AppColor.grayText,
              indicatorColor: AppColor.primaryBlue,
              indicatorWeight: 2.rpx,
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
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: const [
              MineMessageView(key: Key('sys_notice'), type: 6),
              MineMessageView(key: Key('sys_message'), type: 0),
            ],
          ),
        );
      },
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
