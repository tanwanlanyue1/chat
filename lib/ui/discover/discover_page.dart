import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/discover/friend_date/friend_date_page.dart';
import 'package:guanjia/widgets/app_image.dart';

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
      appBar: AppBar(
        title: Text(S.current.discover,style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage("assets/images/discover/activity_back.png"),
        ),
        child: Column(
          children: [
            discoverClassify(),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  ActivityPage(),
                  FriendDatePage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///发现分类
  Widget discoverClassify(){
    return Container(
      padding: EdgeInsets.only(top: 8.rpx),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      height: 40.rpx,
      child: TabBar(
        controller: controller.tabController,
        labelColor: AppColor.primary,
        labelStyle: AppTextStyle.fs14b.copyWith(color: AppColor.primary),
        unselectedLabelColor: AppColor.gray9,
        unselectedLabelStyle: AppTextStyle.fs14b.copyWith(color: AppColor.black92),
        indicatorColor: AppColor.primary,
        indicatorWeight: 2.rpx,
        labelPadding: EdgeInsets.only(bottom: 10.rpx),
        onTap: (val){},
        tabs: [
          Text(S.current.hotActivity),
          Text(S.current.dating),
        ],
      ),
    );
  }
}
