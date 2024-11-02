import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/my_vip/widget/vip_package_list_tile.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'my_vip_controller.dart';

///会员中心
class MyVipPage extends StatelessWidget {
  MyVipPage({super.key});

  final controller = Get.put(MyVipController());
  final state = Get.find<MyVipController>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = state.vipModel.value;

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(S.current.memberCenter),
          backgroundColor: Colors.transparent,
        ),
        body: Builder(builder: (context) {
          final userInfo = model?.userInfo;

          if (model == null || userInfo == null) {
            return const SizedBox();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: AppImage.asset(
                  "assets/images/mine/vip_top_bg.png",
                  width: double.infinity,
                  height: 209.rpx,
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 8.rpx, bottom: 16.rpx),
                        child: Column(
                          children: [
                            buildVipCard(model, userInfo),
                            Container(
                              width: 343.rpx,
                              margin: EdgeInsets.only(top: 12.rpx),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.rpx,
                                vertical: 16.rpx,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildBenefits(model),
                                  buildVipPackage(model),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildFooter(model),
                  ],
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  ///VIP顶部信息卡片
  Widget buildVipCard(VipModel model, UserModel userInfo) {
    return Builder(builder: (context) {
      final userType = userInfo.type;
      final userTypeString = userType.isUser
          ? S.current.user
          : userType.isBeauty
              ? S.current.goodGirl
              : S.current.brokerP;

      return Container(
        width: 343.rpx,
        height: 150.rpx,
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
            userInfo.vip
                ? "assets/images/mine/vip_open.png"
                : "assets/images/mine/vip_unopen.png",
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: Offset(0, 4.rpx),
              blurRadius: 4.rpx,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rpx)
                  .copyWith(top: 20.rpx, bottom: 24.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          UserAvatar.circle(
                            userInfo.avatar ?? "",
                            size: 50.rpx,
                          ),
                          if (userInfo.vip)
                            AppImage.asset(
                              "assets/images/mine/vip_avatar_frame.png",
                              size: 50.rpx,
                            ),
                        ],
                      ),
                      SizedBox(width: 8.rpx),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfo.nickname,
                              style: AppTextStyle.st.medium
                                  .size(18.rpx)
                                  .textColor(AppColor.blackBlue)
                                  .textHeight(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.rpx),
                            Text(userTypeString,
                                style: AppTextStyle.fs12.copyWith(
                                  color: AppColor.tab,
                                  height: 1,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.rpx),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ForegroundGradientMask(
                                gradient: LinearGradient(
                                  colors: userInfo.vip
                                      ? AppColor.horizontalGradient.colors
                                      : const [
                                          AppColor.tab,
                                          AppColor.tab,
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                child: Text(
                                  userInfo.vip
                                      ? S.current.guanJiaVIP
                                      : S.current.becomeGuanJiaVIP,
                                  style: AppTextStyle.fs18.copyWith(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                              ForegroundGradientMask(
                                gradient: LinearGradient(
                                  colors: userInfo.vip
                                      ? const [
                                          AppColor.gradientBackgroundBegin,
                                          AppColor.gradientBackgroundEnd,
                                        ]
                                      : const [
                                          AppColor.tab,
                                          AppColor.tab,
                                        ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                child: Text(
                                  userInfo.vip
                                      ? "${CommonUtils.convertTimestampToString(
                                          userInfo.expirationTime,
                                          newPattern: 'yyyy.MM.dd',
                                        )} ${S.current.expire}"
                                      : S.current.enjoyPremiumBenefits,
                                  style: AppTextStyle.fs12r.copyWith(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!userInfo.vip)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 70.rpx,
                              height: 32.rpx,
                              decoration: BoxDecoration(
                                color: AppColor.tab,
                                borderRadius: BorderRadius.circular(16.rpx),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                S.current.haveNotOpened,
                                style: AppTextStyle.st
                                    .size(14.rpx)
                                    .textColor(Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (model.swiperList.isNotEmpty)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 172.rpx,
                  height: 24.rpx,
                  padding: FEdgeInsets(right: 12.rpx),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.rpx),
                        bottomLeft: Radius.circular(8.rpx)),
                  ),
                  child: Swiper(
                    autoplay: true,
                    autoplayDelay: 5000,
                    loop: true,
                    fade: 0.1,
                    scrollDirection: Axis.vertical,
                    itemCount: model.swiperList.length,
                    duration: 500,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Padding(
                            padding: FEdgeInsets(horizontal: 4.rpx),
                            child: UserAvatar.circle(
                              model.swiperList[index].avatar,
                              size: 16.rpx,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              model.swiperList[index].text,
                              style: AppTextStyle.fs10.copyWith(
                                color: AppColor.tab,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     DefaultTextStyle(
                  //       style: AppTextStyle.st
                  //           .size(10.rpx)
                  //           .textColor(AppColor.tab),
                  //       overflow: TextOverflow.ellipsis,
                  //       child: AnimatedTextKit(
                  //         pause: const Duration(milliseconds: 250),
                  //         repeatForever: true,
                  //         animatedTexts:
                  //             List.generate(model.swiperList.length, (index) {
                  //           final title = model.swiperList[index];
                  //
                  //           return RotateAnimatedText(
                  //             title,
                  //             transitionHeight: 24.rpx,
                  //             alignment: Alignment.centerLeft,
                  //           );
                  //         }),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ),
          ],
        ),
      );
    });
  }

  ///权益
  Widget buildBenefits(VipModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: FEdgeInsets(bottom: 16.rpx),
          child: Text(
            S.current.memberInterests,
            style: AppTextStyle.fs16.copyWith(
              color: AppColor.blackBlue,
              height: 1,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 26.rpx,
            crossAxisSpacing: 39.rpx,
            mainAxisExtent: 44.rpx,
          ),
          itemBuilder: (_, int index) {
            final item = model.benefits[index];
            return Row(
              children: [
                AppImage.network(
                  item.icon,
                  length: 44.rpx,
                ),
                Spacing.w8,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.blackText)
                            .textHeight(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: FEdgeInsets(top: 5.rpx),
                        child: Text(
                          item.subTitle,
                          style: AppTextStyle.fs10r.copyWith(
                            color: AppColor.grayText,
                            height: 1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          itemCount: model.benefits.length,
        ),
      ],
    );
  }

  ///套餐选择
  Widget buildVipPackage(VipModel model) {
    return Obx(() {
      final selectedIndex = state.packagesIndex();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: FEdgeInsets(top: 36.rpx, bottom: 16.rpx),
            child: Text(
              S.current.packageSelection,
              style: AppTextStyle.fs16.copyWith(
                color: AppColor.blackBlue,
                height: 1,
              ),
            ),
          ),
          SizedBox(
            height: 128.rpx,
            child: ListView.separated(
              padding: FEdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                return VipPackageListTile(
                  item: model.packages[index],
                  isSelected: selectedIndex == index,
                  onTap: () => controller.onTapPackages(index),
                );
              },
              separatorBuilder: (_, __) => Spacing.w(10),
              itemCount: model.packages.length,
            ),
          ),
        ],
      );
    });
  }

  Widget buildFooter(VipModel model) {
    return Obx(() {
      final title =
          model.packages.safeElementAt(state.packagesIndex.value)?.title ?? "";

      return Container(
        color: Colors.white,
        width: double.infinity,
        height: 131.rpx + Get.mediaQuery.padding.bottom,
        padding: EdgeInsets.symmetric(horizontal: 28.rpx),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.st
                  .size(12.rpx)
                  .textColor(AppColor.black999)
                  .textHeight(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            CommonGradientButton(
              onTap: controller.onTapOpen,
              height: 50.rpx,
              text: S.current.confirmAgreement,
            ),
            Row(
              children: [
                // GestureDetector(
                //   onTap: controller.onTapSelectProtocol,
                //   child: AppImage.asset(
                //     state.selectProtocol.value
                //         ? "assets/images/order/choose_select.png"
                //         : "assets/images/order/choose_normal.png",
                //     size: 16.rpx,
                //   ),
                // ),
                // SizedBox(width: 8.rpx),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        // TextSpan(
                        //   text: S.current.affirm,
                        //   style: AppTextStyle.st.textColor(AppColor.black999),
                        // ),
                        // TextSpan(
                        //   text: S.current.memberServiceAgreement,
                        //   recognizer: TapGestureRecognizer()
                        //     ..onTap = () {
                        //       WebPage.go(url: AppConfig.urlUserService);
                        //     },
                        // ),
                        TextSpan(
                          text: '点击立即开通即表示同意',
                          style: AppTextStyle.st.textColor(AppColor.black999),
                        ),
                        TextSpan(
                          text: S.current.privacyPolicy,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              WebPage.go(url: AppConfig.urlPrivacyPolicy);
                            },
                        ),
                      ],
                    ),
                    style: AppTextStyle.st
                        .size(12.rpx)
                        .textColor(AppColor.blackBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
