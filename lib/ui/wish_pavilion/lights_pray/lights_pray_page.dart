import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/lights_pray/lights_pray_state.dart';
import 'package:guanjia/ui/wish_pavilion/lights_pray/rendering/lights_pray_sliver_grid.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'lights_pray_controller.dart';

class LightsPrayPage extends StatelessWidget {
  LightsPrayPage({Key? key}) : super(key: key);

  final controller = Get.put(LightsPrayController());
  final state = Get.find<LightsPrayController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
      ),
      body: Container(
        color: const Color(0xFFF6F1E7),
        child: Column(
          children: [
            AppImage.asset(
              "assets/images/wish_pavilion/lights_pray_bg.png",
              height: 200.rpx,
            ),
            Expanded(
              child: Stack(
                children: [
                  buildList(),
                  buildAreaTip(),
                  buildAreaButton(),
                  buildLocation(),
                  buildBottomTip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocation() {
    return GetBuilder<LightsPrayController>(builder: (controller) {
      if (state.myLights.isEmpty) return const SizedBox();
      return Positioned(
        bottom: 173.rpx + Get.mediaQuery.padding.bottom,
        right: 15.rpx,
        child: GestureDetector(
          onTap: () => controller.onTapMyLocation(),
          child: AppImage.asset(
            "assets/images/wish_pavilion/lights_pray_positioning.png",
            width: 50.rpx,
            height: 50.rpx,
          ),
        ),
      );
    });
  }

  Positioned buildBottomTip() {
    return Positioned(
      bottom: 20.rpx + Get.mediaQuery.padding.bottom,
      left: 20.rpx,
      right: 20.rpx,
      child: IgnorePointer(
        child: Column(
          children: [
            Text(
              "请先选位置",
              style: AppTextStyle.st.medium
                  .size(16.rpx)
                  .textColor(AppColor.primary),
            ),
            Container(
              width: 100.rpx,
              height: 6.rpx,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(3.rpx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildAreaButton() {
    return Positioned(
      top: 40.rpx,
      right: 12.rpx,
      child: Obx(() {
        return GestureDetector(
          onTap: () => controller.onTapChangeArea(),
          child: Container(
            width: 60.rpx,
            height: 30.rpx,
            padding: EdgeInsets.only(left: 12.rpx),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              image: AppDecorations.backgroundImage(
                "assets/images/wish_pavilion/lights_pray_choose_location.png",
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              state.area.value.next.name,
              style:
                  AppTextStyle.st.medium.size(14.rpx).textColor(AppColor.gray5),
            ),
          ),
        );
      }),
    );
  }

  Positioned buildAreaTip() {
    return Positioned(
      top: 20.rpx,
      left: 12.rpx,
      child: Obx(() {
        return Container(
          width: 60.rpx,
          height: 70.rpx,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "供灯区",
                style: AppTextStyle.st.medium
                    .size(12.rpx)
                    .textColor(AppColor.gray9),
              ),
              SizedBox(height: 4.rpx),
              Text(
                state.area.value.name,
                style: AppTextStyle.st.medium
                    .size(14.rpx)
                    .textColor(AppColor.gray5),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildList() {
    return LayoutBuilder(builder: (_, constraints) {
      // 赋值列表的约束
      state.listConstraints = constraints;
      return Obx(() {
        return GridViewObserver(
          controller: controller.observerController,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(
                top: 20.rpx, bottom: 12.rpx + Get.mediaQuery.padding.bottom),
            controller: controller.scrollController,
            itemCount: state.items.length,
            gridDelegate: LightsPrayGridDelegate(
              mainAxisSpacing: state.mainAxisSpacing,
              crossAxisSpacing: state.crossAxisSpacing,
              childAspectRatio: state.childAspectRatio,
              length: state.items.length,
            ),
            itemBuilder: (_, int index) {
              var item = state.items.safeElementAt(index);
              if (item == null) return const SizedBox();

              final isExist = item.model != null;
              final isMe = (item.model?.uid ?? 0) == (SS.login.userId ?? -1);

              final imageLength = 46.rpx;

              return GestureDetector(
                onTap: () => controller.onTapChoosePosition(index, item: item),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFD9CC),
                    borderRadius: BorderRadius.circular(4.rpx),
                    border: isMe ? Border.all(color: AppColor.primary) : null,
                    image: isExist
                        ? AppDecorations.backgroundImage(
                            "assets/images/wish_pavilion/lights_pray_item_bg.png")
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6.rpx,
                        child: SizedBox(
                          width: imageLength,
                          height: imageLength,
                          child: isExist
                              ? (item.model!.svga ?? "").isSvga
                                  ? AppImage.networkSvga(
                                      item.model!.svga,
                                      width: imageLength,
                                      height: imageLength,
                                    )
                                  : AppImage.network(
                                      item.model!.lanternImg,
                                      width: imageLength,
                                      height: imageLength,
                                    )
                              : AppImage.asset(
                                  "assets/images/wish_pavilion/lights_pray_item_none.png",
                                ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 20.rpx,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isExist
                                ? isMe
                                    ? AppColor.primary
                                    : null
                                : const Color(0xFFD0C9B9),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(4.rpx),
                            ),
                          ),
                          child: Text(
                            isExist
                                ? item.model!.name
                                : "${item.row}排${item.column}号",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isExist
                                  ? Colors.white
                                  : const Color(0xFF8B8576),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.rpx,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      });
    });
  }
}
