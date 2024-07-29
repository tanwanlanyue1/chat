import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/zen_room_gift_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'zen_room_chant_sutras.dart';
import 'zen_room_gifts_view.dart';

///禅房底部供品面板
class ZenRoomGiftPanel extends StatefulWidget {
  static get height => 212.rpx + Get.padding.bottom;

  const ZenRoomGiftPanel({super.key});

  @override
  State<ZenRoomGiftPanel> createState() => _ZenRoomGiftPanelState();
}

class _ZenRoomGiftPanelState extends State<ZenRoomGiftPanel>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<ZenRoomController>();
  late final state = controller.state;
  late final tabController = TabController(length: GiftPanelTabItem.values.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ZenRoomGiftPanel.height,
      color: const Color(0xFF33251B),
      child: Column(
        children: [
          buildTabBar(),
          Expanded(child: buildTabBarView()),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0x1AFFFFFF))),
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        unselectedLabelColor: const Color(0xCCFFFFFF),
        unselectedLabelStyle: AppTextStyle.fs14m,
        labelColor: Colors.white,
        labelStyle: AppTextStyle.fs16b.copyWith(shadows: [
          Shadow(blurRadius: 4.rpx, offset: Offset(0, 2.rpx)),
        ]),
        indicator: TabUnderlineIndicator(
          width: 16.rpx,
          borderSide: BorderSide(width: 2.rpx, color: Colors.white),
          widthEqualTitle: false,
        ),
        padding: FEdgeInsets(horizontal: 6.rpx),
        labelPadding: FEdgeInsets(horizontal: 10.rpx),
        indicatorPadding: FEdgeInsets(bottom: 2.rpx),
        tabs: GiftPanelTabItem.values.map((item) {
          return Tab(text: item.label, height: 40.rpx);
        }).toList(),
      ),
    );
  }

  Widget buildTabBarView() {
    return Obx(() {
      final selectedGiftsId = state.selectedGiftsIdRx();
      final offeringGifts = state.offeringGiftsRx();
      final incenseList = state.incenseListRx();
      final giftList = state.giftListRx();
      final hasBuddha = state.selectedBuddhaRx() != null;
      return TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ZenRoomGiftsView(
            key: const Key('incense'),
            tab: GiftPanelTabItem.incense,
            hasBuddha: hasBuddha,
            dataList: incenseList,
            selectedId: selectedGiftsId.center,
            offeringGifts: offeringGifts,
            onTapItem: (item) => controller.onSelectedGift(item,GiftPanelTabItem.incense),
            onOfferingFinished: (_) => controller.refreshOfferingGifts(),
            onTapChooseBuddha: controller.onTapChooseBuddha,
            onTapSubmit: () {
              controller.onSubmit(GiftPanelTabItem.incense);
            },
          ),
          ZenRoomGiftsView(
            key: const Key('leftGift'),
            tab: GiftPanelTabItem.leftGift,
            hasBuddha: hasBuddha,
            dataList: giftList,
            selectedId: selectedGiftsId.left,
            offeringGifts: offeringGifts,
            onTapItem: (item) => controller.onSelectedGift(item,GiftPanelTabItem.leftGift),
            onOfferingFinished: (_) => controller.refreshOfferingGifts(),
            onTapChooseBuddha: controller.onTapChooseBuddha,
            onTapSubmit: () {
              controller.onSubmit(GiftPanelTabItem.leftGift);
            },
          ),
          ZenRoomGiftsView(
            key: const Key('rightGift'),
            tab: GiftPanelTabItem.rightGift,
            hasBuddha: hasBuddha,
            dataList: giftList,
            selectedId: selectedGiftsId.right,
            offeringGifts: offeringGifts,
            onTapItem: (item) => controller.onSelectedGift(item,GiftPanelTabItem.rightGift),
            onOfferingFinished: (_) => controller.refreshOfferingGifts(),
            onTapChooseBuddha: controller.onTapChooseBuddha,
            onTapSubmit: () {
              controller.onSubmit(GiftPanelTabItem.rightGift);
            },
          ),
          const ZenRoomChantSutras(),
        ],
      );
    });
  }
}


enum GiftPanelTabItem{
  incense('上香'),
  leftGift('左供品'),
  rightGift('右供品'),
  chantSutras('诵经');
  final String label;
  const GiftPanelTabItem(this.label);
}