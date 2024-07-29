import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/rosary_beads/rosary_beads_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'widigets/merits_increment_view.dart';
import 'widigets/zen_room_gift_panel.dart';
import 'widigets/zen_room_gift_pic.dart';
import 'wooden_fish/wooden_fish_dialog.dart';
import 'zen_room_controller.dart';
import 'zen_room_state.dart';

class ZenRoomPage extends GetView<ZenRoomController> {
  const ZenRoomPage({super.key});

  ZenRoomState get state => controller.state;

  ///佛像图片缓存大小
  static Size get memCacheSize => Size(Get.width * 0.8, Get.width * 0.8 / (24/36));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ZenRoomController>(
      init: ZenRoomController(),
      builder: (_) {
        return VisibilityDetector(
          key: const Key('ZenRoomPage'),
          child: Scaffold(
            backgroundColor: AppColor.brown,
            appBar: buildAppBar(),
            body: buildBody(),
            bottomNavigationBar: buildBottomPanel(),
          ),
          onVisibilityChanged: (event) {
            final controller = Get.tryFind<ZenRoomController>();
            if(event.visibleFraction == 1){
              controller?.startSensor();
            }else{
              controller?.stopSensor();
            }
          },
        );
      },
    );
  }

  ///佛像区域大小
  Size get buddhaArea {
    return controller.buddhaArea;
    // final appbarHeight = kToolbarHeight + Get.mediaQuery.padding.top;
    // final bottomHeight = ZenRoomGiftPanel.height;
    // return Size(
    //   Get.width,
    //   Get.height - appbarHeight - bottomHeight,
    // );
  }

  double get scale => buddhaArea.height / 478.rh;

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: AppBackButton.light(),
      title: buildTitle(),
      actions: [
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.practiceDetailPage);
          },
          style: TextButton.styleFrom(
            minimumSize: Size.fromWidth(88.rpx),
          ),
          child: const Text(
            '修行历史',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget buildTitle() {
    final buddha = state.selectedBuddhaRx();
    if (buddha == null) {
      return Spacing.blank;
    }
    return Container(
      width: 149,
      height: 50,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AppAssetImage('assets/images/wish_pavilion/zen_room/牌匾.png'),
        fit: BoxFit.fill,
      )),
      child: Text(
        buddha.name,
        style: AppTextStyle.notoSerifSC.copyWith(
          color: AppColor.gold,
          fontSize: 19,
          fontWeight: FontWeight.w400,
          height: 1.5,
          shadows: [
            Shadow(
              color: AppColor.brown,
              offset: Offset(0, 1.rpx),
              blurRadius: 2.rpx,
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    final buddha = state.selectedBuddhaRx();
    return Container(
      width: buddhaArea.width,
      height: buddhaArea.height,
      color: const Color(0xFF1A1615),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ObxValue((offsetRx) {
            return Transform.translate(
              offset: offsetRx(),
              child: Transform.scale(
                scale: controller.backgroundScale,
                child: AppImage.asset(
                  'assets/images/wish_pavilion/zen_room/背景.png',
                  width: buddhaArea.width,
                  height: buddhaArea.height,
                  fit: BoxFit.fitHeight,
                ),
              ),
            );
          }, controller.backgroundOffsetRx),
          if (buddha == null) buildSelectBuddha(),
          if (buddha != null) ...[
            buildBuddhaLight(state.prevBuddha, buddha),
            buildBuddha(state.prevBuddha, buddha),
            ObxValue((deskGiftsRx){
              final item = deskGiftsRx().center;
              if(item != null && item.buddhaSvga.startsWith('http')){
                return buildFoWord(item.buddhaSvga);
              }
              return Spacing.blank;
            }, state.deskGiftsRx),
            buildChooseBuddha(),
            buildDesk(),
            buildGifts(),
            buildFaQi(),
            buildZenMeditation(),
          ],
          MeritsIncrementView(
            key: controller.globalKey,
            offset: Offset(buddhaArea.width/2-45.rpx, buddhaArea.height * 0.4),
          ),
        ],
      ),
    );
  }

  ///恭请佛像
  Widget buildSelectBuddha() {
    return Positioned(
      top: 95.rpx * scale,
      child: Container(
        width: buddhaArea.width,
        height: 305.rh * scale,
        alignment: const Alignment(0, 0.28),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AppAssetImage(
              'assets/images/wish_pavilion/zen_room/buddha_placeholder.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: state.isLoading
            ? null
            : GestureDetector(
                onTap: controller.onTapChooseBuddha,
                behavior: HitTestBehavior.translucent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppImage.asset(
                      'assets/images/wish_pavilion/zen_room/ic_plus.png',
                      width: 30.rpx,
                      height: 30.rpx,
                    ),
                    Padding(
                      padding: FEdgeInsets(top: 16.rpx),
                      child: Text(
                        '恭请佛像',
                        style:
                            AppTextStyle.fs20m.copyWith(color: AppColor.gray3),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ///佛光
  Widget buildBuddhaLight(BuddhaModel? prev, BuddhaModel current) {
    return Positioned(
      top: 0,
      child: AppImage.svga(
        key: Key(current.id.toString()),
        'assets/images/wish_pavilion/zen_room/佛光.svga',
        width: 260.rh * scale,
        height: 240.rh * scale,
      ),
    );
  }

  ///佛像
  ///- prev 上一个供奉的佛像
  ///- current 当前供奉的佛像
  Widget buildBuddha(BuddhaModel? prev, BuddhaModel current) {
    final size = Size(240.rh * scale, 360.rh * scale);
    return Positioned(
      top: 54.rh * scale,
      child: SizedBox.fromSize(
        size: size,
        child: TweenAnimationBuilder<double>(
          key: Key(current.id.toString()),
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.decelerate,
          builder: (_, value, child) {
            return Stack(
              children: [
                if (prev != null)
                  Transform.scale(
                    scale: 1 - value,
                    alignment: Alignment.bottomCenter,
                    child: AppImage.network(
                      prev.picture,
                      width: size.width,
                      height: size.height,
                      memCacheWidth: ZenRoomPage.memCacheSize.width,
                      memCacheHeight: ZenRoomPage.memCacheSize.height,
                      opacity: 1 - value,
                      fit: BoxFit.contain,
                    ),
                  ),
                Transform.scale(
                  scale: value,
                  alignment: Alignment.bottomCenter,
                  child: AppImage.network(
                    current.picture,
                    width: size.width,
                    height: size.height,
                    opacity: value,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ///选择佛像
  Widget buildChooseBuddha() {
    return Positioned(
      top: 30.rpx,
      left: 16.rpx,
      child: GestureDetector(
        onTap: controller.onTapChooseBuddha,
        child: Container(
          width: 60.rpx,
          height: 60.rpx,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AppAssetImage(
                  'assets/images/wish_pavilion/zen_room/choose_buddha_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: DefaultTextStyle(
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.brown1,
              height: 1.3,
            ),
            child: const Text('更换\n佛像'),
          ),
        ),
      ),
    );
  }

  ///贡桌
  Widget buildDesk() {

    return ObxValue((offsetRx) {
      return Positioned(
        top: 346.rh * scale + offsetRx().dy,
        left: (Get.width - 321.rh * scale) * 0.5 + offsetRx().dx,
        child: AppImage.asset(
          'assets/images/wish_pavilion/zen_room/贡桌.png',
          width: 321.rh * scale,
          height: 103.rh * scale,
        ),
      );
    }, controller.foregroundOffsetRx);
  }

  ///供品
  Widget buildGifts() {
    final giftSize = Size(78.rh * scale, 78.rh * scale);

    return ObxValue((offsetRx) {
      return Positioned(
        bottom: 91.rh * scale - offsetRx().dy,
        left: (Get.width - 240.rh * scale) * 0.5 + offsetRx().dx,
        child: Obx(() {
          final deskGifts = state.deskGiftsRx();
          final leftGift = deskGifts.left;
          final centerGift = deskGifts.center;
          final rightGift = deskGifts.right;
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox.fromSize(
                size: giftSize,
                child: leftGift != null
                    ? ZenRoomGiftPic(
                  width: giftSize.width,
                  height: giftSize.height,
                  item: leftGift,
                  key: Key('LeftGift${leftGift.id}'),
                )
                    : null,
              ),
              //香炉
              Container(
                width: 60.rh * scale,
                height: 120.rh * scale,
                margin: EdgeInsets.symmetric(horizontal: 12.rh),
                child: centerGift != null ? buildCenser(centerGift) : null,
              ),
              SizedBox.fromSize(
                size: giftSize,
                child: rightGift != null
                    ? ZenRoomGiftPic(
                  width: giftSize.width,
                  height: giftSize.height,
                  item: rightGift,
                  key: Key('RightGift${rightGift.id}'),
                )
                    : null,
              ),
            ],
          );
        }),
      );
    }, controller.foregroundOffsetRx);
  }

  ///香炉
  Widget buildCenser(ZenRoomGiftModel item) {
    return SizedBox(
      width: 60.rh * scale,
      height: 120.rh * scale,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          AppImage.network(
            item.image,
            width: 60.rh * scale,
            height: 120.rh * scale,
            fit: BoxFit.contain,
            align: Alignment.bottomCenter,
          ),
          if (item.smokeSvga.startsWith('http'))
            Positioned(
              top: -50.rh * scale,
              child: AppImage.networkSvga(
                item.smokeSvga,
                width: 60.rh * scale,
                height: 60.rh * scale,
              ),
            ),
        ],
      ),
    );
  }

  ///佛(字效)
  Widget buildFoWord(String svgaUrl) {
    return Positioned(
      // top: -130.rh * scale,
      bottom: 170.rh * scale,
      child: AppImage.networkSvga(
        svgaUrl,
        width: 155.rh * scale,
        height: 150.rh * scale,
        repeat: false,
      ),
    );
  }

  ///法器：念珠，木鱼
  Widget buildFaQi() {
    return Positioned(
      top: 34.rpx,
      right: 16.rpx,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScaleButton(
            onTap: (){
              Get.to(() => RosaryBeadsPage());
            },
            child: AppImage.asset(
              'assets/images/wish_pavilion/zen_room/念珠.png',
              width: 60.rh * scale,
              height: 60.rh * scale,
            ),
          ),
          Padding(
            padding: FEdgeInsets(top: 16.rpx),
            child: AnimatedScaleButton(
              onTap: WoodenFishDialog.show,
              child: AppImage.asset(
                'assets/images/wish_pavilion/zen_room/木鱼.png',
                width: 60.rh * scale,
                height: 60.rh * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///禅垫
  Widget buildZenMeditation() {

    return ObxValue((offsetRx) {
      return Positioned(
        top: 418.rh * scale + offsetRx().dy,
        left: (Get.width - 140.rh * scale) * 0.5 + offsetRx().dx,
        child: Center(
          child: GestureDetector(
            onTap: controller.fetchZenLanguage,
            child: AppImage.asset(
              'assets/images/wish_pavilion/zen_room/禅垫.png',
              width: 140.rh * scale,
              height: 70.rh * scale,
            ),
          ),
        ),
      );
    }, controller.foregroundOffsetRx);
  }

  ///底部面板
  Widget buildBottomPanel() {
    return Container(
      width: double.infinity,
      height: ZenRoomGiftPanel.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AppAssetImage(
            'assets/images/wish_pavilion/zen_room/bottom_panel_bg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: const ZenRoomGiftPanel(),
    );
  }
}
