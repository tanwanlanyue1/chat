import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/common/utils/un_listview.dart';
import 'package:guanjia/widgets/advertising_swiper.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/system_ui.dart';

import 'mine_controller.dart';
import 'mine_state.dart';

///我的
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(MineController());
  final state = Get.find<MineController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SystemUI.dark(
      child: Container(
        color: AppColor.brown14,
        child: Stack(
          children: [
            // AppImage.asset(
            //   "assets/images/mine/mine_backage.png",
            //   height: 236.rpx,
            // ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 44.rpx),
                  height: 44.rpx,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(AppRoutes.accountDataPage);
                    },
                    // child: Padding(
                    //   padding: EdgeInsets.only(
                    //       left: 24.rpx,
                    //       right: 12.rpx,
                    //       top: 10.rpx,
                    //       bottom: 10.rpx),
                    //   child: AppImage.asset(
                    //     'assets/images/mine/compile.png',
                    //     width: 24.rpx,
                    //     height: 24.rpx,
                    //   ),
                    // ),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // _header(),
                        SizedBox(height: 12.rpx),
                        _discipline(),
                        AdvertisingSwiper(
                          position: 1,
                          insets: EdgeInsets.symmetric(horizontal: 12.rpx),
                        ),
                        _personalService(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 头部
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Visibility(
              visible: !controller.loginService.isLogin,
              replacement: _logInHead(),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: controller.onTapLogin,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 27.rpx, right: 8.rpx),
                      child: AppImage.asset(
                        "assets/images/mine/notLogIn.png",
                        width: 58.rpx,
                        height: 58.rpx,
                      ),
                    ),
                    Text(
                      "登录/注册",
                      style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  /// 头像
  Widget _logInHead() {
    return Column(
      children: [
        Container(
          height: 58.rpx,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.rpx),
            ),
          ),
          padding: EdgeInsets.only(left: 27.rpx),
          child: Obx(() {
            return Row(
              children: [
                Obx(() {
                  return GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.accountDataPage),
                    child: AppImage.network(
                      controller.loginService.info?.avatar ?? "",
                      width: 58.rpx,
                      height: 58.rpx,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
                SizedBox(width: 8.rpx),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.accountDataPage),
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.rpx),
                          child: Text(
                            controller.loginService.info?.nickname ?? "",
                            style: AppTextStyle.fs16m
                                .copyWith(color: AppColor.gray5),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            Visibility(
                              visible: false,
                              child: Container(
                                margin: EdgeInsets.only(right: 8.rpx),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0x268D310F),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2.rpx))),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.rpx),
                                height: 14.rpx,
                                child: Text(
                                  "",
                                  style: AppTextStyle.fs10m.copyWith(
                                      color: AppColor.red1, height: 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.rpx),
                            AppImage.asset(
                              "assets/images/mine/mine_down_arrow.png",
                              width: 12.rpx,
                              height: 12.rpx,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ],
    );
  }

  /// 修行之路
  Widget _discipline() {
    return Container(
      padding: EdgeInsets.all(12.rpx),
      child: GestureDetector(
        onTap: () {
          if (state.current.value == 0) {
            state.current.value = 1;
          } else {
            state.current.value = 0;
          }
        },
        child: Obx(() {
          final value = state.current();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                width: 100.rpx,
                child: Text('顾客'),
                onPressed: value == 0 ? null : () => state.current.value = 0,
              ),
              Button(
                width: 100.rpx,
                child: Text('佳丽'),
                onPressed: value == 1 ? null : () => state.current.value = 1,
              ),
              Button(
                width: 100.rpx,
                child: Text('经纪人'),
                onPressed: value == 2 ? null : () => state.current.value = 2,
              ),
            ],
          );
        }),
      ),
    );
  }

  /// 功能类型
  Widget _personalService() {
    return Container(
      width: 351.rpx,
      decoration: const BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: ScrollConfiguration(
        behavior: ChatScrollBehavior(),
        child: Obx(() => Column(
              children: List.generate(
                  state.current.value == 0
                      ? state.commonFeature.length
                      : state.current.value == 1
                          ? state.jiaCommonFeature.length
                          : state.brokerCommonFeature.length, (index) {
                MineItemSource item = state.current.value == 0
                    ? state.commonFeature[index]
                    : state.current.value == 1
                        ? state.jiaCommonFeature[index]
                        : state.brokerCommonFeature[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.onTapItem(item.type),
                  child: SizedBox(
                    height: 48.rpx,
                    child: Row(
                      children: [
                        AppImage.asset(
                          '${item.icon}',
                          width: 24.rpx,
                          height: 24.rpx,
                        ),
                        SizedBox(
                          width: 12.rpx,
                        ),
                        Text(
                          '${item.title}',
                          style: AppTextStyle.fs14m
                              .copyWith(color: AppColor.gray5),
                        ),
                        const Spacer(),
                        AppImage.asset(
                          'assets/images/mine/mine_right.png',
                          width: 20.rpx,
                          height: 20.rpx,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
