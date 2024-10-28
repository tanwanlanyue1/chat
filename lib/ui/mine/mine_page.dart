import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/open_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_recharge_dialog.dart';
import 'package:guanjia/ui/map/map_page.dart';
import 'package:guanjia/ui/mine/widgets/beautiful_status_tips.dart';
import 'package:guanjia/ui/mine/widgets/mine_list_tile.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/recaptcha_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/network/api/model/user/talk_user.dart';
import 'mine_controller.dart';
import 'widgets/beautiful_status_switch.dart';
import 'widgets/hole_painter.dart';

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
    final padding = FEdgeInsets(top: 182.rpx + Get.mediaQuery.padding.top);
    return SystemUI.light(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: padding,
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: FEdgeInsets(bottom: 24.rpx, horizontal: 16.rpx),
                      children: [
                        buildBanner(),
                        buildSectionOne(),
                        buildSectionTwo(),
                        buildSignOutButton(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: buildMask(),
                ),
                buildHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMask() {
    return CustomPaint(
      size: Size(Get.width, 16.rpx),
      painter: HolePainter(
        color: AppColor.scaffoldBackground,
        padding: FEdgeInsets(horizontal: 16.rpx, top: 8.rpx),
        radius: 8.rpx,
      ),
    );
  }

  ///头部
  Widget buildHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        //背景
        Container(
          width: double.infinity,
          height: 150.rpx + Get.mediaQuery.padding.top,
          margin: FEdgeInsets(bottom: 28.rpx),
          decoration: const BoxDecoration(
            gradient: AppColor.horizontalGradient,
          ),
        ),
        //用户信息
        buildUserInfo(),
      ],
    );
  }

  ///用户信息
  Widget buildUserInfo() {
    return Obx(() {
      final userInfo = SS.login.info;
      final status = state.beautifulStatusRx;
      final userType = userTypeRx;
      final isVip = SS.login.isVip;
      var position = userInfo?.position ?? '';
      if (position.isEmpty) {
        position = S.current.regionUnknown;
      }

      return Padding(
        padding: FEdgeInsets(horizontal: 16.rpx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null && userType.isBeauty)
              BeautifulStatusTips(status: status),
            buildShadowBox(
              width: double.infinity,
              height: 130.rpx,
              margin: FEdgeInsets(top: 8.rpx),
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.userCenterPage,
                        arguments: {'userId': userInfo!.uid}),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        AppImage.network(
                          userInfo?.avatar ?? '',
                          width: 90.rpx,
                          height: 90.rpx,
                          shape: BoxShape.circle,
                        ),
                        if (isVip)
                          AppImage.asset(
                            'assets/images/mine/ic_vip.png',
                            width: 24.rpx,
                            height: 24.rpx,
                          ),
                      ],
                    ),
                  ),
                  Spacing.w12,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          minFontSize: 10,
                          maxLines: 1,
                          userInfo?.nickname ?? '',
                          style: AppTextStyle.fs18m.copyWith(
                            color: AppColor.blackBlue,
                            height: 1.0,
                          ),
                        ),
                        Padding(
                          padding: FEdgeInsets(top: 12.rpx),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      position,
                                      style: AppTextStyle.fs14.copyWith(
                                        color: AppColor.black999,
                                        height: 1.0,
                                      ),
                                    ),
                                    if (userInfo?.chatNo != null)
                                      GestureDetector(
                                        onTap: () =>
                                            '${userInfo?.chatNo}'.copy(),
                                        behavior: HitTestBehavior.translucent,
                                        child: Padding(
                                          padding: FEdgeInsets(top: 12.rpx),
                                          child: Text(
                                            'ID:${userInfo?.chatNo}',
                                            style: AppTextStyle.fs12.copyWith(
                                              color: AppColor.black999,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (status != null && userType.isBeauty)
                                Padding(
                                  padding: FEdgeInsets(left: 4.rpx),
                                  child: BeautifulStatusSwitch(
                                    status: status,
                                    onChange: controller.onTapBeautifulStatus,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  ///广告
  Widget buildBanner() {
    return Obx((){
      final list = SS.ad.bannerMapRx()[1] ?? [];
      if(list.isEmpty){
        return Spacing.blank;
      }
      return Padding(
        padding: FEdgeInsets(top: 8.rpx, bottom: 8.rpx),
        child: AspectRatio(
          aspectRatio: 1029/240,
          child: Swiper(
            autoplay: list.length > 1,
            loop: list.length > 1,
            duration: 500,
            autoplayDelay: 5000,
            physics: list.length > 1 ? null : const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final item = list.tryGet(index);
              return AppImage.network(
                item?.image ?? '',
                align: Alignment.topCenter,
                borderRadius: BorderRadius.circular(8.rpx),
              );
            },
            itemCount: list.length,
            onTap: (index){
              final item = list.tryGet(index);
              final url = item?.gotoUrl;
              if(item != null && url != null){
                AppLink.jump(
                  url,
                  title: item.title,
                  args: item.gotoParam?.toJson(),
                );
              }
            },
          ),
        ),
      );
    });
  }

  ///阴影框
  Widget buildShadowBox({
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Widget? child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.rpx,
            offset: Offset(0, 8.rpx),
          ),
        ],
      ),
      child: child,
    );
  }

  ///分组项
  Widget buildSection({
    required List<Widget> children,
    EdgeInsetsGeometry? margin,
  }) {
    return buildShadowBox(
      margin: margin,
      width: double.infinity,
      child: Column(
        children: children.separated(const Divider(height: 0)).toList(),
      ),
    );
  }

  UserType get userTypeRx => SS.login.info?.type ?? UserType.user;

  ///第1部分
  Widget buildSectionOne() {
    return Obx(() {
      final userType = userTypeRx;
      return buildSection(
        margin: FEdgeInsets(top: 4.rpx),
        children: [
          //个人信息
          MineListTile(
            title: S.current.personalInformation,
            icon: "assets/images/mine/personal_info.png",
            pagePath: AppRoutes.accountDataPage,
          ),
          //我的钱包
          MineListTile(
            title: S.current.myWallet,
            icon: "assets/images/mine/wallet.png",
            pagePath: AppRoutes.walletPage,
          ),
          //我的VIP
          MineListTile(
            title: S.current.myVIP,
            icon: "assets/images/mine/VIP.png",
            pagePath: AppRoutes.myVipPage,
          ),
          //我的客户
          if (userType.isBeauty)
            MineListTile(
              title: S.current.myCustomer,
              icon: "assets/images/mine/mine_client.png",
              pagePath: AppRoutes.mineClient,
            ),
          //我的评价
          if (userType.isUser)
            MineListTile(
              title: S.current.myAssessment,
              icon: "assets/images/mine/evaluate.png",
              pagePath: AppRoutes.mineEvaluatePage,
            ),
          //我的设置
          MineListTile(
            title: S.current.mySettings,
            icon: "assets/images/mine/setting.png",
            pagePath: AppRoutes.mineSettingPage,
          ),
          //激活/进阶
          MineListTile(
            title: S.current.activationProgression,
            icon: "assets/images/mine/activate.png",
            trailing: userType.isUser
                ? S.current.normalUser
                : (userType.isBeauty
                    ? S.current.beautifulUser
                    : S.current.brokerUser),
            onTap: controller.onTapUserAdvanced,
          ),
          //评价我的
          if (userType.isBeauty)
            MineListTile(
              title: S.current.appraiseMe,
              icon: "assets/images/mine/evaluate.png",
              pagePath: AppRoutes.jiaEvaluatePage,
            ),
          //团队评价
          if (userType.isAgent)
            MineListTile(
              title: S.current.teamEvaluation,
              icon: "assets/images/mine/evaluate.png",
              pagePath: AppRoutes.mineTeamEvaluatePage,
            ),
          //我的团队
          if (userType.isAgent)
            MineListTile(
              title: S.current.myTeam,
              icon: "assets/images/mine/my_team.png",
              pagePath: AppRoutes.mineMyTeamPage,
            ),
        ],
      );
    });
  }

  ///第2部分
  Widget buildSectionTwo() {
    return Obx(() {
      final userType = userTypeRx;
      return buildSection(
        margin: FEdgeInsets(top: 16.rpx),
        children: [
          //谁看过我
          MineListTile(
            title: S.current.whoSeenMe,
            icon: "assets/images/mine/examine.png",
            pagePath: AppRoutes.haveSeenPage,
            badge: SS.appConfig.configRx.value?.lookMessage,
          ),
          //修改服务费
          if (userType.isBeauty)
            MineListTile(
              title: S.current.modificationServiceCharge,
              icon: "assets/images/mine/modification_service.png",
              pagePath: AppRoutes.mineServiceChargePage,
            ),
          //查看契约单
          if (userType.isBeauty)
            MineListTile(
              title: S.current.contractDetail,
              icon: "assets/images/mine/look_contract.png",
              pagePath: AppRoutes.contractListPage,
            ),
          //生成契约单
          if (userType.isAgent)
            MineListTile(
              title: S.current.generateContract,
              icon: "assets/images/mine/look_contract.png",
              pagePath: AppRoutes.contractGeneratePage,
            ),
          //意见反馈
          MineListTile(
            title: S.current.feedback,
            icon: "assets/images/mine/feedback.png",
            pagePath: AppRoutes.mineFeedbackPage,
          ),
          MineListTile(
            title: S.current.myMessage,
            icon: "assets/images/mine/message.png",
            pagePath: AppRoutes.mineMessage,
            badge: (SS.inAppMessage.latestSysNoticeRx()?.total ?? 0) > 0,
          ),
        ],
      );
    });
  }

  Widget buildSignOutButton() {
    return Center(
      child: Button(
        margin: FEdgeInsets(top: 24.rpx),
        width: 200.rpx,
        height: 46.rpx,
        onPressed: controller.onTapSignOut,
        child: Text(S.current.signOut, style: AppTextStyle.fs16),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
