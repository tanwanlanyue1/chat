import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/attention_or_fans/mine_attention/mine_attention_page.dart';
import 'package:guanjia/ui/mine/attention_or_fans/mine_fans/mine_fans_page.dart';
import 'package:guanjia/widgets/tab_underline_indicator.dart';

import 'attention_or_fans_controller.dart';

class AttentionOrFansPage extends StatelessWidget {
  AttentionOrFansPage({Key? key}) : super(key: key);

  final controller = Get.put(AttentionOrFansController());
  final state = Get.find<AttentionOrFansController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        title: Container(
          color: Colors.white,
          child: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            labelColor: AppColor.gray5,
            labelPadding: EdgeInsets.symmetric(horizontal: 12.rpx)
                .copyWith(top: 12.rpx, bottom: 6.rpx),
            indicator: TabUnderlineIndicator(
              width: 20.rpx,
              borderSide: const BorderSide(width: 3.0, color: AppColor.primary),
              widthEqualTitle: false,
            ),
            indicatorColor: AppColor.primary,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16.rpx),
            labelStyle:
                TextStyle(fontSize: 16.rpx, fontWeight: FontWeight.bold),
            unselectedLabelColor: AppColor.gray9,
            unselectedLabelStyle:
                TextStyle(fontSize: 16.rpx, fontWeight: FontWeight.w500),
            // indicator: const BoxDecoration(),
            onTap: (index) {
              controller.onTapTabIndex(index);
            },
            tabs: List.generate(
              state.tabTitles.length,
              (index) => Text(state.tabTitles[index]),
            ),
          ),
        ),
      ),
      body: Obx(() {
        return (state.tabIndex.value == 0)
            ? MineAttentionPage()
            : MineFansPage(
              appBar: false,
        );
      }),
    );
  }
}
