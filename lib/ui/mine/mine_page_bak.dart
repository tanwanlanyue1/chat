import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/mine_list_tile.dart';
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
class MinePageBak extends StatefulWidget {
  const MinePageBak({super.key});

  @override
  State<MinePageBak> createState() => _MinePageState();
}

class _MinePageState extends State<MinePageBak>
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
            child: ListView(
              padding: FEdgeInsets(horizontal: 16.rpx),
              children: [
                buildBanner(),
                buildSectionOne(),
              ],
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
        Positioned(
          child: buildShadowBox(
              width: 343.rpx,
              height: 130.rpx,
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AppImage.network(
                        width: 90.rpx,
                        height: 90.rpx,
                        shape: BoxShape.circle,
                        'https://pic1.zhimg.com/v2-dbbe270b44aebc392b71c83ad61b9ef1.jpg?source=8673f162',
                      ),
                      AppImage.asset(
                        'assets/images/mine/ic_vip.png',
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ],
                  ),
                  Spacing.w12,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Landon',
                          style: AppTextStyle.fs18m.copyWith(
                            color: AppColor.gray5,
                          ),
                        ),
                        Padding(
                          padding: FEdgeInsets(vertical: 4.rpx),
                          child: Text(
                            '中国·北京',
                            style: AppTextStyle.fs16m.copyWith(
                              color: AppColor.gray9,
                            ),
                          ),
                        ),
                        Text(
                          'ID:1754654458',
                          style: AppTextStyle.fs12m.copyWith(
                            color: AppColor.gray9,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
    );
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
          children: children.separated(Divider()).toList(),
        ));
  }

  ///第一部分
  Widget buildSectionOne(){
    return buildSection(
      children: [
        //个人信息
        MineListTile(
          title: S.current.personalInformation,
          icon: "assets/images/mine/personal_info.png",
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
        //我的VIP
        MineListTile(
          title: S.current.myVIP,
          icon: "assets/images/mine/VIP.png",
        ),
      ],
    );
  }



  @override
  bool get wantKeepAlive => true;
}
