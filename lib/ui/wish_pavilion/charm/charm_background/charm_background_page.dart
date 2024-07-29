import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_background_preview/charm_background_preview_dialog.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/tab_underline_indicator.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../../common/network/api/api.dart';
import 'charm_background_controller.dart';

class CharmBackgroundPage extends StatelessWidget {
  CharmBackgroundPage({super.key});

  final controller = Get.put(CharmBackgroundController());
  final state = Get.find<CharmBackgroundController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "灵符壁纸",
          style: AppTextStyle.st.size(18.rpx).textColor(Colors.white),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
        actions: [
          GestureDetector(
            onTap: controller.onTapMe,
            child: Container(
              margin: EdgeInsets.only(right: 12.rpx),
              alignment: Alignment.center,
              child: Text(
                "我的",
                style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildTopBackground(),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Container(
                margin: EdgeInsets.only(top: 20.rpx),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F3E8),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: controller.tabController,
                      isScrollable: true,
                      labelColor: AppColor.gray5,
                      labelPadding: EdgeInsets.symmetric(horizontal: 12.rpx)
                          .copyWith(top: 12.rpx, bottom: 6.rpx),
                      indicator: TabUnderlineIndicator(
                        width: 20.rpx,
                        borderSide: const BorderSide(
                            width: 3.0, color: AppColor.primary),
                        widthEqualTitle: false,
                      ),
                      indicatorColor: AppColor.primary,
                      indicatorPadding:
                          EdgeInsets.symmetric(horizontal: 16.rpx),
                      labelStyle: TextStyle(
                          fontSize: 16.rpx, fontWeight: FontWeight.bold),
                      unselectedLabelColor: AppColor.gray9,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 16.rpx, fontWeight: FontWeight.w500),
                      // indicator: const BoxDecoration(),
                      onTap: (index) {
                        controller.onTapTabIndex(index);
                      },
                      tabs: List.generate(
                        state.tabTitles.length,
                        (index) => Text(state.tabTitles[index]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 12.rpx, vertical: 15.rpx),
                      child: Row(
                        children: [
                          AppImage.asset(
                            "assets/images/wish_pavilion/charm/background_dot.png",
                            width: 16.rpx,
                            height: 16.rpx,
                          ),
                          SizedBox(width: 4.rpx),
                          Text.rich(
                            TextSpan(
                              text: "全部灵符壁纸均",
                              children: [
                                TextSpan(
                                  text: "已开光加持",
                                  style: AppTextStyle.st.bold
                                      .size(14.rpx)
                                      .textColor(const Color(0xFF967336)),
                                ),
                                const TextSpan(text: ",心力相通,感应作用更强!"),
                              ],
                            ),
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller:
                            controller.pagingController.refreshController,
                        onRefresh: controller.pagingController.onRefresh,
                        child: PagedListView(
                          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                          pagingController: controller.pagingController,
                          builderDelegate:
                              DefaultPagedChildBuilderDelegate<CharmRes>(
                            pagingController: controller.pagingController,
                            itemBuilder: (
                              _,
                              model,
                              index,
                            ) {
                              return _buildItem(model);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack _buildItem(CharmRes model) {
    final isHot = model.extraConfig == 1;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.rpx, horizontal: 12.rpx),
          margin: EdgeInsets.only(bottom: 12.rpx),
          decoration: BoxDecoration(
            image: AppDecorations.backgroundImage(
                "assets/images/wish_pavilion/charm/item_bg.png"),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 12.rpx),
                child: AppImage.network(
                  width: 90.rpx,
                  height: 120.rpx,
                  model.perfectImageUrl,
                  fit: BoxFit.cover,
                  align: Alignment.bottomCenter,
                  borderRadius: BorderRadius.circular(4.rpx),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: AppTextStyle.st.bold
                          .size(14.rpx)
                          .textColor(AppColor.gray5),
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.rpx),
                    SizedBox(
                      height: 32.rpx,
                      child: SingleChildScrollView(
                        child: Text(
                          model.remark,
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(AppColor.gray30),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.rpx),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                CharmBackgroundPreviewDialog(
                                  model.perfectImageUrl,
                                ),
                                useSafeArea: false,
                              );
                            },
                            child: Container(
                              width: 100.rpx,
                              height: 30.rpx,
                              decoration: BoxDecoration(
                                image: AppDecorations.backgroundImage(
                                    "assets/images/wish_pavilion/charm/item_button_bg_gray.png"),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "壁纸预览",
                                style: AppTextStyle.st.medium
                                    .size(12.rpx)
                                    .textColor(const Color(0xFF3B2121)),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 21.rpx,
                                child: Visibility(
                                  visible: model.isHave == 0,
                                  child: Row(
                                    children: [
                                      AppImage.asset(
                                        "assets/images/wish_pavilion/charm/item_gold.png",
                                        width: 14.rpx,
                                        height: 14.rpx,
                                      ),
                                      SizedBox(width: 4.rpx),
                                      Text(
                                        "${model.goldNum}",
                                        style: AppTextStyle.st.bold
                                            .size(12.rpx)
                                            .textColor(AppColor.primary),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.rpx),
                              GestureDetector(
                                onTap: () => controller.onPaymentOrSafe(model),
                                child: Container(
                                  width: 100.rpx,
                                  height: 30.rpx,
                                  decoration: BoxDecoration(
                                    image: AppDecorations.backgroundImage(
                                      model.isHave == 0
                                          ? "assets/images/wish_pavilion/charm/item_button_bg_yellow.png"
                                          : "assets/images/wish_pavilion/charm/item_button_bg_red.png",
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    model.isHave == 0 ? "永久拥有" : "已拥有,保存",
                                    style: AppTextStyle.st.medium
                                        .size(12.rpx)
                                        .textColor(Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isHot,
          child: Positioned(
            child: AppImage.asset(
              "assets/images/wish_pavilion/charm/item_hot.png",
              width: 20.rpx,
              height: 20.rpx,
            ),
          ),
        ),
      ],
    );
  }

  /// 顶部背景
  Positioned _buildTopBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        "assets/images/wish_pavilion/charm/background_title_bg.png",
        height:
            52.rpx + Get.mediaQuery.padding.top + kBottomNavigationBarHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}
