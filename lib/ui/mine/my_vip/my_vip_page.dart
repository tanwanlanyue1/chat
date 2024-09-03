import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'my_vip_controller.dart';

class MyVipPage extends StatelessWidget {
  MyVipPage({super.key});

  final controller = Get.put(MyVipController());
  final state = Get.find<MyVipController>().state;

  @override
  Widget build(BuildContext context) {
    bool isVip = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('会员中心'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
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
                          final userType = SS.login.userType;
                          final userTypeString = userType.isUser
                              ? '用户'
                              : userType.isBeauty
                                  ? '佳丽'
                                  : '经纪人';

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
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.rpx)
                                  .copyWith(top: 20.rpx, bottom: 24.rpx),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          AppImage.network(
                                            SS.login.avatar,
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
                                              SS.login.nickname,
                                              style: AppTextStyle.st.medium
                                                  .size(18.rpx)
                                                  .textColor(AppColor.blackBlue)
                                                  .textHeight(1),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 6.rpx),
                                            Text(
                                              userTypeString,
                                              style: AppTextStyle.st
                                                  .size(12.rpx)
                                                  .textColor(AppColor.tab)
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
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GradientText(
                                                isVip ? "管家VIP" : "成为管家VIP",
                                                style: AppTextStyle.st
                                                    .size(18.rpx)
                                                    .textHeight(1),
                                                colors: isVip
                                                    ? const [
                                                        AppColor.gradientBegin,
                                                        AppColor.gradientEnd,
                                                      ]
                                                    : const [
                                                        AppColor.tab,
                                                        AppColor.tab,
                                                      ],
                                              ),
                                              GradientText(
                                                isVip
                                                    ? "2024.08.28 到期"
                                                    : "开通立享超值会员权益",
                                                style: AppTextStyle.st
                                                    .size(12.rpx),
                                                gradientDirection:
                                                    GradientDirection.ttb,
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
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              width: 70.rpx,
                                              height: 32.rpx,
                                              decoration: BoxDecoration(
                                                color: AppColor.tab,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.rpx),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "未开通",
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
                                "会员尊享权益",
                                style: AppTextStyle.st
                                    .size(16.rpx)
                                    .textColor(AppColor.blackBlue)
                                    .textHeight(1),
                              ),
                              SizedBox(height: 16.rpx),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 26.rpx,
                                  crossAxisSpacing: 39.rpx,
                                  mainAxisExtent: 44.rpx,
                                ),
                                itemBuilder: (_, int index) {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "1次/月",
                                              style: AppTextStyle.st
                                                  .size(14.rpx)
                                                  .textColor(AppColor.blackText)
                                                  .textHeight(1),
                                            ),
                                            Text(
                                              "会员尊享权益",
                                              style: AppTextStyle.st
                                                  .size(10.rpx)
                                                  .textColor(AppColor.grayText)
                                                  .textHeight(1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: 4,
                              ),
                              SizedBox(height: 36.rpx),
                              Text(
                                "套餐选择",
                                style: AppTextStyle.st
                                    .size(16.rpx)
                                    .textColor(AppColor.blackBlue)
                                    .textHeight(1),
                              ),
                              SizedBox(height: 16.rpx),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, int index) {
                                  final radius = 8.rpx;

                                  return Container(
                                    height: 76.rpx,
                                    decoration: BoxDecoration(
                                      color: AppColor.background,
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24.rpx),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "1个月",
                                                style: AppTextStyle.st
                                                    .size(14.rpx)
                                                    .textColor(
                                                        AppColor.blackBlue),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\$",
                                                        style: AppTextStyle.st
                                                            .size(18.rpx)
                                                            .textColor(AppColor
                                                                .blackBlue),
                                                      ),
                                                      Text(
                                                        "28",
                                                        style: AppTextStyle.st
                                                            .size(24.rpx)
                                                            .textColor(AppColor
                                                                .blackBlue),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$28",
                                                    style: AppTextStyle.st
                                                        .size(16.rpx)
                                                        .textColor(
                                                            AppColor.grayText)
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
                                        Container(
                                          width: 56.rpx,
                                          height: 18.rpx,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(radius),
                                              bottomRight:
                                                  Radius.circular(radius),
                                            ),
                                            gradient:
                                                AppColor.horizontalGradient,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "限时特惠",
                                            style: AppTextStyle.st
                                                .size(12.rpx)
                                                .textColor(Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 8.rpx),
                                itemCount: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 131.rpx + Get.mediaQuery.padding.bottom,
                  padding: EdgeInsets.symmetric(horizontal: 28.rpx),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "每月续费，续费前提醒，可关闭",
                        style: AppTextStyle.st
                            .size(12.rpx)
                            .textColor(AppColor.black999)
                            .textHeight(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CommonGradientButton(
                        height: 50.rpx,
                        text: "确认协议并立即开通",
                      ),
                      Row(
                        children: [
                          AppImage.asset(
                            isVip
                                ? "assets/images/order/choose_select.png"
                                : "assets/images/order/choose_normal.png",
                            length: 16.rpx,
                          ),
                          SizedBox(width: 8.rpx),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "确认",
                                    style: AppTextStyle.st
                                        .textColor(AppColor.black999),
                                  ),
                                  TextSpan(
                                    text: "《会员服务协议》",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap =
                                          () => controller.onTapProtocol(1),
                                  ),
                                  TextSpan(
                                    text: "《自动续费协议》",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap =
                                          () => controller.onTapProtocol(2),
                                  ),
                                  TextSpan(
                                    text: "《隐私政策》",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap =
                                          () => controller.onTapProtocol(3),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
