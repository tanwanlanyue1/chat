import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'my_vip_controller.dart';

class MyVipPage extends StatelessWidget {
  MyVipPage({super.key});

  final controller = Get.put(MyVipController());
  final state = Get.find<MyVipController>().state;

  @override
  Widget build(BuildContext context) {
    bool isVip = true;

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
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 8.rpx),
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
                                        ShaderMask(
                                          shaderCallback: (bounds) {
                                            final gradient = isVip
                                                ? AppColor.horizontalGradient
                                                : const LinearGradient(
                                                    colors: [
                                                      AppColor.tab,
                                                      AppColor.tab
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  );

                                            return gradient
                                                .createShader(bounds);
                                          },
                                          child: Text(
                                            isVip ? "管家VIP" : "成为管家VIP",
                                            style: AppTextStyle.st
                                                .size(18.rpx)
                                                .textHeight(1),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // const Spacer(),
                                        ShaderMask(
                                          shaderCallback: (bounds) {
                                            final gradient = isVip
                                                ? AppColor.horizontalGradient
                                                : const LinearGradient(
                                                    colors: [
                                                      AppColor.tab,
                                                      AppColor.tab
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  );

                                            return gradient
                                                .createShader(bounds);
                                          },
                                          child: Text(
                                            isVip
                                                ? "2024.08.28 到期"
                                                : "开通立享超值会员权益",
                                            style: AppTextStyle.st.size(12.rpx),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                                              BorderRadius.circular(16.rpx),
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
                    height: 150.rpx,
                    margin: EdgeInsets.only(top: 12.rpx),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            const gradient = LinearGradient(
                              colors: [Colors.white, AppColor.black3],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            );

                            return gradient.createShader(bounds);
                          },
                          child: Text(
                            "成为管家VIP",
                            style: AppTextStyle.st
                                .size(34.rpx)
                                .textColor(Colors.blue)
                                .textHeight(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GradientText(
                          'Gradient Text',
                          style: AppTextStyle.st
                              .size(34.rpx)
                              .textColor(Colors.blue)
                              .textHeight(1),
                          colors: [
                            Colors.black,
                            Colors.yellow,
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
