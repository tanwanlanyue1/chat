import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/cultivation_ranking/cultivation_ranking_view.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/merit_ranking/merit_ranking_view.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'merit_cultivation_ranking_controller.dart';

///功德修行-排行榜
class MeritCultivationRankingPage extends StatelessWidget {
  MeritCultivationRankingPage({
    super.key,
    this.initialIndex = 0,
  });

  // 默认跳转功德排行 0：功德 1：修行
  final int initialIndex;

  late final controller = Get.find<MeritCultivationRankingController>();
  late final state = Get.find<MeritCultivationRankingController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeritCultivationRankingController>(
      init: MeritCultivationRankingController(initialIndex: initialIndex),
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColor.brown12,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            padding: FEdgeInsets(top: 206.rpx),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AppAssetImage(
                  'assets/images/wish_pavilion/zen_room/merit_list_bg.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )),
            child: Column(
              children: [
                buildTabBar(),
                Expanded(child: buildTabBarView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTabBar() {
    Widget buildTab({
      required String text,
      required bool isSelected,
      VoidCallback? onTap,
      int position = 0,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 175.rpx,
          height: isSelected ? 46.rpx : 36.rpx,
          alignment: Alignment.center,
          decoration: isSelected
              ? const BoxDecoration(
                  image: DecorationImage(
                    image: AppAssetImage(
                        'assets/images/wish_pavilion/zen_room/merit_list_tab.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        position == 0 ? Radius.circular(12.rpx) : Radius.zero,
                    topRight:
                        position == 1 ? Radius.circular(12.rpx) : Radius.zero,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFF6DD),
                      Color(0xFFF7EFE3),
                    ],
                  ),
                ),
          child: Text(
            text,
            style: isSelected
                ? TextStyle(
                    fontSize: 18.rpx,
                    fontWeight: FontWeight.bold,
                    color: AppColor.brown13,
                  )
                : TextStyle(
                    fontSize: 16.rpx,
                    fontWeight: FontWeight.w500,
                    color: AppColor.gray9,
                  ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: controller.tabController,
      builder: (_, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['功德排行', '修行榜'].mapIndexed((index, item) {
            return buildTab(
              text: item,
              isSelected: controller.tabController.index == index,
              position: index,
              onTap: () {
                controller.tabController.index = index;
              },
            );
          }).toList(growable: false),
        );
      },
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MeritRankingView(),
        CultivationRankingView(),
      ],
    );
  }
}
