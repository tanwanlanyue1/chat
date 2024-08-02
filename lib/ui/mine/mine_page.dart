import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/beautiful_status_tips.dart';
import 'package:guanjia/ui/mine/widgets/mine_list_tile.dart';
import 'package:guanjia/ui/mine/widgets/role_visibility.dart';
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
import 'widgets/activation_progression.dart';
import 'widgets/beautiful_status_switch.dart';
import 'widgets/security_deposit_dialog.dart';

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
    return SystemUI.light(
      child: Column(
        children: [
          buildHeader(),
          Expanded(
            child: SmartRefresher(
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              child: ListView(
                padding: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx),
                children: [
                  buildBanner(),
                  buildSectionOne(),
                  buildSectionTwo(),
                  buildSignOutButton(),
                ],
              ),
            ),
          ),
        ],
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
            gradient: LinearGradient(
              colors: [
                AppColor.gradientBackgroundBegin,
                AppColor.gradientBackgroundEnd,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
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
      final statusRx = state.beautifulStatusRx;

      return Padding(
        padding: FEdgeInsets(horizontal: 16.rpx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (statusRx != null)
              BeautyVisible(child: BeautifulStatusTips(status: statusRx)),
            buildShadowBox(
              width: double.infinity,
              height: 130.rpx,
              margin: FEdgeInsets(top: 8.rpx),
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.accountDataPage),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        AppImage.network(
                          userInfo?.avatar ?? '',
                          width: 90.rpx,
                          height: 90.rpx,
                          shape: BoxShape.circle,
                        ),
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
                          maxLines: 2,
                          userInfo?.nickname ?? '',
                          style: AppTextStyle.fs18m.copyWith(
                            color: AppColor.gray5,
                          ),
                        ),
                        if (userInfo?.position?.isNotEmpty == true)
                          Padding(
                            padding: FEdgeInsets(top: 4.rpx),
                            child: Text(
                              userInfo?.position ?? '',
                              style: AppTextStyle.fs16m.copyWith(
                                color: AppColor.gray9,
                              ),
                            ),
                          ),
                        if (userInfo?.chatNo != null)
                          GestureDetector(
                            onTap: () => '${userInfo?.chatNo}'.copy(),
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: FEdgeInsets(top: 4.rpx),
                              child: Text(
                                'ID:${userInfo?.chatNo}',
                                style: AppTextStyle.fs12m.copyWith(
                                  color: AppColor.gray9,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (statusRx != null)
                    BeautyVisible(
                      child: Padding(
                        padding: FEdgeInsets(left: 4.rpx),
                        child: BeautifulStatusSwitch(
                          status: statusRx,
                          onChange: controller.onTapBeautifulStatus,
                        ),
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
    return Padding(
      padding: FEdgeInsets(vertical: 24.rpx),
      child: AppImage.asset(
        width: double.infinity,
        fit: BoxFit.fitWidth,
        'assets/images/mine/banner.png',
      ),
    );
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

  ///第1部分
  Widget buildSectionOne() {
    return buildSection(
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
        ),
        //我的VIP
        MineListTile(
          title: S.current.myVIP,
          icon: "assets/images/mine/VIP.png",
        ),
        //我的客户
        MineListTile(
          title: S.current.myCustomer,
          icon: "assets/images/mine/mine_client.png",
        ),
        //我的评价
        UserVisible(
          child: MineListTile(
            title: S.current.myAssessment,
            icon: "assets/images/mine/evaluate.png",
            pagePath: AppRoutes.mineEvaluatePage,
          ),
        ),
        //意见反馈
        MineListTile(
          title: S.current.feedback,
          icon: "assets/images/mine/feedback.png",
          pagePath: AppRoutes.mineFeedbackPage,
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
          trailing: S.current.normalUser,
          onTap: () {
            ActivationProgression.show();
          },
        ),
        //解约/进阶为经纪人
        MineListTile(
          title: S.current.cancelAdvanceToBroker,
          icon: "assets/images/mine/cancel_a_contract.png",
          trailing: S.current.beautifulUser,
        ),
        //评价我的
        MineListTile(
          title: S.current.appraiseMe,
          icon: "assets/images/mine/evaluate.png",
          pagePath: AppRoutes.jiaEvaluatePage,
        ),
        //团队评价
        MineListTile(
          title: S.current.teamEvaluation,
          icon: "assets/images/mine/evaluate.png",
          pagePath: AppRoutes.mineTeamEvaluatePage,
        ),
        //我的团队
        MineListTile(
          title: S.current.myTeam,
          icon: "assets/images/mine/my_team.png",
          trailing: S.current.brokerUser,
          pagePath: AppRoutes.mineMyTeamPage,
        ),
      ],
    );
  }

  ///第2部分
  Widget buildSectionTwo() {
    return buildSection(
      margin: FEdgeInsets(top: 16.rpx),
      children: [
        //谁看过我
        MineListTile(
          title: S.current.whoSeenMe,
          icon: "assets/images/mine/examine.png",
          pagePath: AppRoutes.haveSeenPage,
        ),
        //修改服务费
        MineListTile(
          title: S.current.modificationServiceCharge,
          icon: "assets/images/mine/modification_service.png",
          pagePath: AppRoutes.mineServiceChargePage,
        ),
        //查看契约单
        MineListTile(
          title: S.current.contractDetail,
          icon: "assets/images/mine/look_contract.png",
          pagePath: AppRoutes.contractListPage,
        ),
        //生成契约单
        MineListTile(
          title: S.current.generateContract,
          icon: "assets/images/mine/look_contract.png",
          pagePath: AppRoutes.contractGeneratePage,
        ),
        //我的消息
        MineListTile(
          title: S.current.myMessage,
          icon: "assets/images/mine/message.png",
          pagePath: AppRoutes.mineMessage,
        ),
      ],
    );
  }

  Widget buildSignOutButton() {
    return Center(
      child: Button(
        margin: FEdgeInsets(top: 24.rpx),
        width: 200.rpx,
        height: 46.rpx,
        onPressed: controller.onTapSignOut,
        child: Text(S.current.signOut, style: AppTextStyle.fs16m),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
