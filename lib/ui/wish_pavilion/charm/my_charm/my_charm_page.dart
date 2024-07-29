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
import 'package:guanjia/common/utils/image_gallery_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/tab_underline_indicator.dart';
import 'package:guanjia/widgets/widgets.dart';
import '../../../../common/network/api/api.dart';
import '../widgets/charm_background_preview/charm_background_preview_dialog.dart';
import 'my_charm_controller.dart';

class MyCharmPage extends StatelessWidget {
  MyCharmPage({super.key});

  final controller = Get.put(MyCharmController());
  final state = Get.find<MyCharmController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "我的灵符",
          style: AppTextStyle.st.size(18.rpx).textColor(Colors.white),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppImage.asset(
                            "assets/images/wish_pavilion/charm/background_dot.png",
                            width: 16.rpx,
                            height: 16.rpx,
                          ),
                          SizedBox(width: 4.rpx),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "已拥有的灵符（图片）可存至（相册）后再 ",
                                children: [
                                  TextSpan(
                                    text: "设为手机壁纸",
                                    style: AppTextStyle.st.bold
                                        .size(14.rpx)
                                        .textColor(const Color(0xFF967336)),
                                  ),
                                  const TextSpan(text: " 保佑平安，化解生活不顺!"),
                                ],
                              ),
                              style: AppTextStyle.st
                                  .size(14.rpx)
                                  .textColor(AppColor.gray5),
                            ),
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
                              DefaultPagedChildBuilderDelegate<CharmRecord>(
                            pagingController: controller.pagingController,
                            itemBuilder: (
                              _,
                              model,
                              index,
                            ) {
                              final imageRadius = 4.rpx;

                              final isLight = model.lightStatus == 1;
                              final isBless = model.blessStatus == 1;
                              final isGetMav = model.isGetMav == 1;

                              String stateTitle;
                              Color stateColor;

                              if (isLight && isBless) {
                                stateTitle = isGetMav ? "已领取" : "领取功德奖励";
                                stateColor = isGetMav
                                    ? const Color(0xFF999999)
                                    : const Color(0xFF00A742);
                              } else {
                                stateTitle = "开光 | 加持";
                                stateColor = const Color(0xFFE4A547);
                              }

                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.rpx, horizontal: 12.rpx),
                                margin: EdgeInsets.only(bottom: 12.rpx),
                                decoration: BoxDecoration(
                                  image: AppDecorations.backgroundImage(
                                      "assets/images/wish_pavilion/charm/item_bg.png"),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 12.rpx),
                                      width: 90.rpx,
                                      height: 120.rpx,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(imageRadius),
                                      ),
                                      child: Stack(
                                        children: [
                                          AppImage.network(
                                            model.currentStateImageUrl,
                                            width: 90.rpx,
                                            height: 120.rpx,
                                            fit: BoxFit.cover,
                                            align: Alignment.bottomCenter,
                                            borderRadius:
                                                BorderRadius.circular(4.rpx),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.rpx,
                                                    vertical: 5.rpx),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xC2000000),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        imageRadius),
                                                    bottomRight:
                                                        Radius.circular(
                                                            imageRadius),
                                                  ),
                                                ),
                                                child: Text(
                                                  "${model.count}张",
                                                  style: AppTextStyle.st.medium
                                                      .size(10.rpx)
                                                      .textColor(Colors.white),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => isLight && isBless
                                                    ? isGetMav
                                                        ? null
                                                        : controller
                                                            .onGetMav(model)
                                                    : controller
                                                        .onTapPut(model),
                                                child: Container(
                                                  height: 24.rpx,
                                                  decoration: BoxDecoration(
                                                    color: stateColor,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom: Radius.circular(
                                                          imageRadius),
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    stateTitle,
                                                    style: AppTextStyle
                                                        .st.medium
                                                        .size(10.rpx)
                                                        .textColor(
                                                            Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                model.name,
                                                style: AppTextStyle.st.bold
                                                    .size(14.rpx)
                                                    .textColor(AppColor.gray5),
                                                maxLines: 1,
                                              ),
                                              Text.rich(
                                                maxLines: 1,
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "(${model.lightStatus == 1 ? "已" : "可"}开光)",
                                                      style: AppTextStyle
                                                          .st.bold
                                                          .size(14.rpx)
                                                          .textColor(model
                                                                      .lightStatus ==
                                                                  1
                                                              ? AppColor.gray9
                                                              : const Color(
                                                                  0xFFE4A547)),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "(${model.blessStatus == 1 ? "已" : "可"}加持)",
                                                      style: AppTextStyle
                                                          .st.bold
                                                          .size(14.rpx)
                                                          .textColor(model
                                                                      .blessStatus ==
                                                                  1
                                                              ? AppColor.gray9
                                                              : const Color(
                                                                  0xFFE4A547)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.dialog(
                                                      CharmBackgroundPreviewDialog(
                                                        model
                                                            .currentStateImageUrl,
                                                      ),
                                                      useSafeArea: false,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 100.rpx,
                                                    height: 30.rpx,
                                                    decoration: BoxDecoration(
                                                      image: AppDecorations
                                                          .backgroundImage(
                                                              "assets/images/wish_pavilion/charm/item_button_bg_gray.png"),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "壁纸预览",
                                                      style: AppTextStyle
                                                          .st.medium
                                                          .size(12.rpx)
                                                          .textColor(
                                                              const Color(
                                                                  0xFF3B2121)),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 18.rpx),
                                                    GestureDetector(
                                                      onTap: () {
                                                        ImageGalleryUtils
                                                            .saveNetworkImage(model
                                                                .currentStateImageUrl);
                                                      },
                                                      child: Container(
                                                        width: 100.rpx,
                                                        height: 30.rpx,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: AppDecorations
                                                              .backgroundImage(
                                                                  "assets/images/wish_pavilion/charm/item_button_bg_red.png"),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "保存至相册",
                                                          style: AppTextStyle
                                                              .st.medium
                                                              .size(12.rpx)
                                                              .textColor(
                                                                  Colors.white),
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
                              );
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
