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
        title: Text(S.current.discover),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: controller.tabController,
          labelStyle: AppTextStyle.fs14b,
          labelColor: AppColor.primaryBlue,
          unselectedLabelColor: AppColor.grayText,
          indicatorColor: AppColor.primaryBlue,
          indicatorWeight: 2.rpx,
          onTap: (val) {},
          tabs: [
            Tab(text: S.current.hotActivity, height: 40.rpx),
            Tab(text: S.current.dating, height: 40.rpx),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AppAssetImage(
              'assets/images/discover/activity_back.png',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            ActivityPage(),
            FriendDatePage(),
          ],
        ),
      ),
    );
  }

}
