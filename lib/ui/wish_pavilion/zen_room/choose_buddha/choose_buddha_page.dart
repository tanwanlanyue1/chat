import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'choose_buddha_controller.dart';
import 'choose_buddha_state.dart';

///恭请佛像
class ChooseBuddhaPage extends GetView<ChooseBuddhaController> {
  const ChooseBuddhaPage({super.key});

  ///当前选中的佛像ID
  static Future<BuddhaModel?> go(
      {int? selectedId, required List<BuddhaModel> buddhaList}) async {
    final result = await Get.toNamed(AppRoutes.qingFoPage, arguments: {
      'selectedId': selectedId,
      'buddhaList': buddhaList,
    });
    if (result is BuddhaModel) {
      return result;
    }
    return null;
  }

  ChooseBuddhaState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: navigator?.maybePop,
          child: const Text(
            '取消',
            style: TextStyle(color: AppColor.gray5),
          ),
        ),
        title: const Text('恭请佛像', style: TextStyle(color: AppColor.gray5)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: state.selectedItemRx);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: AppColor.gray5),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.brown3,
      body: buildBody(),
      bottomNavigationBar: buildBottomPanel(),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AppAssetImage(
              'assets/images/wish_pavilion/zen_room/qing_fo_bg.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            buildPageView(),
            buildFoName(),
            buildDesc(),
          ],
        ),
      ),
    );
  }

  Widget buildPageView() {
    return Positioned.fill(
      child: PageView(
        controller: controller.pageController,
        children: state.buddhaList.map((item) {
          return Align(
            alignment: const Alignment(0, -0.8),
            child: AppImage.network(
              item.picture,
              width: 237.rpx,
              height: 360.rpx,
              memCacheWidth: ZenRoomPage.memCacheSize.width,
              memCacheHeight: ZenRoomPage.memCacheSize.height,
              fit: BoxFit.contain,
            ),
          );
        }).toList(growable: false),
      ),
    );
  }

  Widget buildFoName() {
    return Positioned.fill(
      child: Align(
        alignment: const Alignment(0, -0.8),
        child: Container(
          height: 360.rpx,
          padding: FEdgeInsets(right: 20.rpx),
          alignment: Alignment.topRight,
          child: Container(
            width: 44.rpx,
            height: 130.rpx,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AppAssetImage(
                  'assets/images/wish_pavilion/zen_room/fo_name_card.png',
                ),
              ),
            ),
            child: Obx(() {
              final name =
                  (state.selectedItemRx?.name ?? '').split('').join('\n');
              return Text(
                name,
                style: AppTextStyle.fs16b.copyWith(
                  color: AppColor.brown4,
                  height: 18 / 16,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildDesc() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        final desc = state.selectedItemRx?.introduce;
        final isExpanded = state.isExpandedRx();
        if (desc == null) {
          return Spacing.blank;
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: state.isExpandedRx.toggle,
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 50.rpx,
                height: 25.rpx,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.brown6,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.rpx)),
                ),
                child: AppImage.asset(
                  isExpanded
                      ? 'assets/images/common/ic_arrow_down_white.png'
                      : 'assets/images/common/ic_arrow_up_white.png',
                  width: 16.rpx,
                  height: 16.rpx,
                ),
              ),
            ),
            Container(
              color: AppColor.brown6,
              padding: FEdgeInsets(all: 12.rpx),
              child: Text(
                desc,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: AppTextStyle.fs14m.copyWith(color: Colors.white),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget buildBottomPanel() {
    final list = state.buddhaList;
    return Obx(() {
      final selectedId = state.selectedIdRx();
      return Container(
        color: AppColor.brown4,
        padding:
            FEdgeInsets(bottom: max(Get.mediaQuery.padding.bottom - 15.rpx, 0)),
        child: SizedBox(
          height: 100.rpx,
          child: ListView.separated(
            controller: controller.scrollController,
            scrollDirection: Axis.horizontal,
            padding: FEdgeInsets(horizontal: 12.rpx, vertical: 15.rpx),
            itemBuilder: (_, index) {
              final item = list[index];
              return buildBuddhaItem(
                item: item,
                isSelected: selectedId == item.id,
                onTap: () => controller.setSelectedBuddha(item),
              );
            },
            separatorBuilder: (_, index) => Spacing.w12,
            itemCount: list.length,
          ),
        ),
      );
    });
  }

  Widget buildBuddhaItem({
    required BuddhaModel item,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.rpx,
        height: 70.rpx,
        padding: FEdgeInsets(all: 4.rpx),
        foregroundDecoration: isSelected
            ? null
            : BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4.rpx),
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: AppColor.gold7,
        ),
        child: AppImage.network(
          item.picture,
          fit: BoxFit.contain,
          width: 62.rpx,
          height: 62.rpx,
        ),
      ),
    );
  }
}
