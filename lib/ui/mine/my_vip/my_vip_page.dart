import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'my_vip_controller.dart';

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

          bool isVip = userInfo.vip;

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
                            Builder(builder: (context) {
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
                                    isVip
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
                                      padding: EdgeInsets.symmetric(
                                              horizontal: 16.rpx)
                                          .copyWith(
                                              top: 20.rpx, bottom: 24.rpx),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  AppImage.network(
                                                    userInfo.avatar ?? "",
                                                    length: 50.rpx,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  if (isVip)
                                                    AppImage.asset(
                                                      "assets/images/mine/vip_avatar_frame.png",
                                                      length: 50.rpx,
                                                    ),
                                                ],
                                              ),
                                              SizedBox(width: 8.rpx),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      userInfo.nickname,
                                                      style: AppTextStyle
                                                          .st.medium
                                                          .size(18.rpx)
                                                          .textColor(AppColor
                                                              .blackBlue)
                                                          .textHeight(1),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 6.rpx),
                                                    Text(
                                                      userTypeString,
                                                      style: AppTextStyle.st
                                                          .size(12.rpx)
                                                          .textColor(
                                                              AppColor.tab)
                                                          .textHeight(1),
                                                    ),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GradientText(
                                                        isVip
                                                            ? S.current.guanJiaVIP
                                                            : S.current.becomeGuanJiaVIP,
                                                        style: AppTextStyle.st
                                                            .size(18.rpx)
                                                            .textHeight(1),
                                                        colors: isVip
                                                            ? const [
                                                                AppColor
                                                                    .gradientBegin,
                                                                AppColor
                                                                    .gradientEnd,
                                                              ]
                                                            : const [
                                                                AppColor.tab,
                                                                AppColor.tab,
                                                              ],
                                                      ),
                                                      GradientText(
                                                        isVip
                                                            ? "${CommonUtils.convertTimestampToString(
                                                                userInfo
                                                                    .expirationTime,
                                                                newPattern:
                                                                    'yyyy.MM.dd',
                                                              )} ${S.current.expire}"
                                                            : S.current.enjoyPremiumBenefits,
                                                        style: AppTextStyle.st
                                                            .size(12.rpx),
                                                        gradientDirection:
                                                            GradientDirection
                                                                .ttb,
                                                        colors: isVip
                                                            ? const [
                                                                AppColor
                                                                    .gradientBackgroundBegin,
                                                                AppColor
                                                                    .gradientBackgroundEnd,
                                                              ]
                                                            : const [
                                                                AppColor.tab,
                                                                AppColor.tab,
                                                              ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (!isVip)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      width: 70.rpx,
                                                      height: 32.rpx,
                                                      decoration: BoxDecoration(
                                                        color: AppColor.tab,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    16.rpx),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        S.current.haveNotOpened,
                                                        style: AppTextStyle.st
                                                            .size(14.rpx)
                                                            .textColor(
                                                                Colors.white),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                          width: 160.rpx,
                                          height: 24.rpx,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.rpx),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.04),
                                            borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(8.rpx),
                                                bottomLeft:
                                                    Radius.circular(8.rpx)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DefaultTextStyle(
                                                style: AppTextStyle.st
                                                    .size(10.rpx)
                                                    .textColor(AppColor.tab),
                                                overflow: TextOverflow.ellipsis,
                                                child: AnimatedTextKit(
                                                  pause: const Duration(
                                                      milliseconds: 250),
                                                  repeatForever: true,
                                                  animatedTexts: List.generate(
                                                      model.swiperList.length,
                                                      (index) {
                                                    final title =
                                                        model.swiperList[index];

                                                    return RotateAnimatedText(
                                                      title,
                                                      transitionHeight: 24.rpx,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            Container(
                              width: 343.rpx,
                              margin: EdgeInsets.only(top: 12.rpx),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.rpx, vertical: 16.rpx),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.memberInterests,
                                    style: AppTextStyle.st
                                        .size(16.rpx)
                                        .textColor(AppColor.blackBlue)
                                        .textHeight(1),
                                  ),
                                  SizedBox(height: 16.rpx),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.title,
                                                  style: AppTextStyle.st
                                                      .size(14.rpx)
                                                      .textColor(
                                                          AppColor.blackText)
                                                      .textHeight(1),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  item.subTitle,
                                                  style: AppTextStyle.st
                                                      .size(10.rpx)
                                                      .textColor(
                                                          AppColor.grayText)
                                                      .textHeight(1),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: model.benefits.length,
                                  ),
                                  SizedBox(height: 36.rpx),
                                  Text(
                                    S.current.packageSelection,
                                    style: AppTextStyle.st
                                        .size(16.rpx)
                                        .textColor(AppColor.blackBlue)
                                        .textHeight(1),
                                  ),
                                  SizedBox(height: 16.rpx),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, int index) {
                                      final radius = 8.rpx;

                                      final item = model.packages[index];

                                      return Obx(() {
                                        final isSelect =
                                            index == state.packagesIndex.value;

                                        return GestureDetector(
                                          onTap: () =>
                                              controller.onTapPackages(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radius + 1),
                                              gradient: isSelect
                                                  ? AppColor.horizontalGradient
                                                  : null,
                                            ),
                                            child: Container(
                                              height: 76.rpx,
                                              decoration: BoxDecoration(
                                                color: AppColor.background,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radius),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 24.rpx),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          S.current.entriesMonth(item.duration),
                                                          style: AppTextStyle.st
                                                              .size(14.rpx)
                                                              .textColor(AppColor
                                                                  .blackBlue),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Baseline(
                                                                  baseline:
                                                                      22.rpx,
                                                                  baselineType:
                                                                      TextBaseline
                                                                          .alphabetic,
                                                                  child: Text(
                                                                    "\$",
                                                                    style: AppTextStyle
                                                                        .st
                                                                        .size(18
                                                                            .rpx)
                                                                        .textColor(isSelect
                                                                            ? AppColor.primaryBlue
                                                                            : AppColor.blackBlue),
                                                                  ),
                                                                ),
                                                                Baseline(
                                                                  baseline:
                                                                      24.rpx,
                                                                  baselineType:
                                                                      TextBaseline
                                                                          .alphabetic,
                                                                  child:
                                                                      GradientText(
                                                                    item.discountPrice !=
                                                                            0
                                                                        ? item
                                                                            .discountPrice
                                                                            .toString()
                                                                        : item
                                                                            .price
                                                                            .toString(),
                                                                    colors: isSelect
                                                                        ? const [
                                                                            AppColor.gradientBegin,
                                                                            AppColor.gradientEnd,
                                                                          ]
                                                                        : const [
                                                                            AppColor.blackBlue,
                                                                            AppColor.blackBlue,
                                                                          ],
                                                                    style: AppTextStyle
                                                                        .st
                                                                        .size(24
                                                                            .rpx),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (item.discountPrice !=
                                                                0)
                                                              Text(
                                                                "\$${item.price}",
                                                                style: AppTextStyle
                                                                    .st
                                                                    .size(
                                                                        16.rpx)
                                                                    .textColor(
                                                                        AppColor
                                                                            .grayText)
                                                                    .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                    ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (item.discount == 1)
                                                    Container(
                                                      width: 56.rpx,
                                                      height: 18.rpx,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  radius),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  radius),
                                                        ),
                                                        gradient: AppColor
                                                            .horizontalGradient,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        S.current.flashSales,
                                                        style: AppTextStyle.st
                                                            .size(12.rpx)
                                                            .textColor(
                                                                Colors.white),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 8.rpx),
                                    itemCount: model.packages.length,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      final title = model.packages
                              .safeElementAt(state.packagesIndex.value)
                              ?.title ??
                          "";

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
                                GestureDetector(
                                  onTap: controller.onTapSelectProtocol,
                                  child: AppImage.asset(
                                    state.selectProtocol.value
                                        ? "assets/images/order/choose_select.png"
                                        : "assets/images/order/choose_normal.png",
                                    length: 16.rpx,
                                  ),
                                ),
                                SizedBox(width: 8.rpx),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: S.current.affirm,
                                          style: AppTextStyle.st
                                              .textColor(AppColor.black999),
                                        ),
                                        TextSpan(
                                          text: S.current.memberServiceAgreement,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                controller.onTapProtocol(1),
                                        ),
                                        // TextSpan(
                                        //   text: "《自动续费协议》",
                                        //   recognizer: TapGestureRecognizer()
                                        //     ..onTap = () =>
                                        //         controller.onTapProtocol(2),
                                        // ),
                                        TextSpan(
                                          text: S.current.privacyPolicy,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                controller.onTapProtocol(3),
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
                    }),
                  ],
                ),
              ),
            ],
          );
        }),
      );
    });
  }
}
