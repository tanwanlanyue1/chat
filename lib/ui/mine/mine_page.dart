import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/common/utils/un_listview.dart';
import 'package:guanjia/ui/mine/widgets/mine_item.dart';
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
            AppImage.asset(
              "assets/images/mine/mine_backage.png",
              height: 236.rpx,
            ),
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
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 24.rpx,
                          right: 12.rpx,
                          top: 10.rpx,
                          bottom: 10.rpx),
                      child: AppImage.asset(
                        'assets/images/mine/compile.png',
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _header(),
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
        Container(
          height: 74.rpx,
          margin: EdgeInsets.only(top: 16.rpx, left: 12.rpx, right: 12.rpx),
          decoration: BoxDecoration(
            image: AppDecorations.backgroundImage(
                "assets/images/mine/merits_back.png"),
          ),
          child: Obx(() {
            return Row(
              children: [
                _meritVirtue(),
                _balance(),
              ],
            );
          }),
        ),
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
                        onTap: controller.onTapPractice,
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            Visibility(
                              visible: controller.loginService.levelMoneyInfo
                                      ?.cavLevelName !=
                                  null,
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
                                  controller.loginService.levelMoneyInfo
                                          ?.cavLevelName ??
                                      "",
                                  style: AppTextStyle.fs10m.copyWith(
                                      color: AppColor.red1, height: 1),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                nextLevelText,
                                style: AppTextStyle.fs12m
                                    .copyWith(color: AppColor.gray9),
                                overflow: TextOverflow.ellipsis,
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

  String get nextLevelText {
    final info = controller.loginService.levelMoneyInfo;
    final cavExpDiff = info?.cavExpDiff ?? 0;
    final cavDayDiff = info?.cavDayDiff ?? 0;
    if (cavExpDiff > 0) {
      return "距离下一级还需修行值$cavExpDiff";
    } else {
      return "距离下一级还需修行$cavDayDiff天";
    }
  }

  /// 功德
  Widget _meritVirtue() {
    final mavLevelName =
        controller.loginService.levelMoneyInfo?.mavLevelName ?? "";

    return Expanded(
      child: GestureDetector(
        onTap: controller.onTapMeritVirtue,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(left: 30.rpx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "功德",
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                  ),
                  Visibility(
                    visible: controller.loginService.isLogin &&
                        mavLevelName.isNotEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.brown14,
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.rpx))),
                      margin: EdgeInsets.only(left: 6.rpx),
                      padding: EdgeInsets.symmetric(horizontal: 2.rpx),
                      height: 18.rpx,
                      child: Text(
                        controller.loginService.levelMoneyInfo?.mavLevelName ??
                            "",
                        style: AppTextStyle.fs12m
                            .copyWith(color: AppColor.brown36),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                controller.loginService.isLogin
                    ? "${controller.loginService.levelMoneyInfo?.mavExp ?? 0}"
                    : "———",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 22.rpx,
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 余额
  Widget _balance() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 30.rpx),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "余额",
                  style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                ),
                if (controller.loginService.isLogin)
                  Container(
                    margin: EdgeInsets.only(left: 8.rpx),
                    child: GestureDetector(
                      onTap: () => controller.onTapGoldDetails(),
                      child: Text(
                        "明细>",
                        style: AppTextStyle.fs12m
                            .copyWith(color: AppColor.brown36),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.rpx),
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    minFontSize: 10,
                    maxLines: 1,
                    controller.loginService.isLogin
                        ? "${controller.loginService.levelMoneyInfo?.money ?? 0}"
                        : "———",
                    style: TextStyle(
                        fontSize: 22.rpx,
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (controller.loginService.isLogin)
                  GestureDetector(
                    onTap: () => controller.onTapPurchase(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.gray5,
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.rpx))),
                      margin: EdgeInsets.only(left: 8.rpx, right: 12.rpx),
                      padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                      height: 20.rpx,
                      alignment: Alignment.center,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.brown42, AppColor.brown43],
                          ).createShader(Offset.zero & bounds.size);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          "充值",
                          style: AppTextStyle.fs12b.copyWith(height: 1.0000001),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 修行之路
  Widget _discipline() {
    return Container(
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("修行之路",
                    style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5)),
                // GestureDetector(
                //   onTap: () => controller.onTapMissionCenter(),
                //   child: Text("任务中心>", style: TextStyle(fontSize: 12.rpx)),
                // ),
              ],
            ),
          ),
          MineItem(
            onTap: (index) =>
                controller.onTapItem(state.discipline[index].type),
            items: state.discipline,
            iconLength: 44.rpx,
            mainAxisExtent: 72.rpx,
          ),
        ],
      ),
    );
  }

  /// 功能类型
  Widget _personalService() {
    return Container(
      width: 351.rpx,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AppAssetImage(
            'assets/images/mine/buddha.png',
          ),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: ScrollConfiguration(
        behavior: ChatScrollBehavior(),
        child: Column(
          children: List.generate(state.commonFeature.length, (index) {
            MineItemSource item = state.commonFeature[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  controller.onTapItem(state.commonFeature[index].type),
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
                      style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                    ),
                    const Spacer(),
                    AppImage.asset(
                      'assets/images/mine/enter_into.png',
                      width: 20.rpx,
                      height: 20.rpx,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
