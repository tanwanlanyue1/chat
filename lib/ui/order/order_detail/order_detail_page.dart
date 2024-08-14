import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/title_space_between_widget.dart';

import 'order_detail_controller.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key});

  final controller = Get.find<OrderDetailController>();
  final state = Get.find<OrderDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '订单详情',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppImage.asset(
              "assets/images/order/detail_top_bg.png",
              height: Get.padding.top + kNavigationBarHeight + 162.rpx,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.rpx)
                        .copyWith(top: 16.rpx, bottom: 24.rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "等待佳丽接单中···",
                          style: AppTextStyle.st.medium
                              .size(20.rpx)
                              .textColor(Colors.white),
                          maxLines: 2,
                        ),
                        SizedBox(height: 8.rpx),
                        Text(
                          "佳丽正在接单中，请耐心等待哦~",
                          style: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(Colors.white),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                      child: Container(
                        width: Get.width - 32.rpx,
                        constraints: BoxConstraints(
                          minHeight: (Get.width - 32.rpx) * 486 / 343,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.rpx, vertical: 16.rpx),
                        decoration: BoxDecoration(
                          image: AppDecorations.backgroundImage(
                            "assets/images/order/detail_content_bg.png",
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "订单编号：",
                                  detail: "235654641235654641235",
                                ),
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "下单用户：",
                                  detail: "帅气小奶狗",
                                  detailLeading: Container(
                                    color: AppColor.primary,
                                    width: 24.rpx,
                                    height: 24.rpx,
                                    margin: EdgeInsets.only(right: 8.rpx),
                                  ),
                                ),
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "接单佳丽：",
                                  detail: "帅气小奶狗",
                                  detailLeading: Container(
                                    color: AppColor.primary,
                                    width: 24.rpx,
                                    height: 24.rpx,
                                    margin: EdgeInsets.only(right: 8.rpx),
                                  ),
                                ),
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "下单时间：",
                                  detail: "2024/09/03 19:16",
                                ),
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "接单时间：",
                                  detail: "2024/09/03 19:16",
                                ),
                                _buildUpTitleSpaceBetweenWidget(
                                  title: "结束时间：",
                                  detail: "2024/09/03 19:16",
                                ),
                                Divider(
                                  height: 33.rpx,
                                  color: AppColor.scaffoldBackground,
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "保证金：",
                                  detail: "800.00",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "用户缴纳服务费：",
                                  detail: "1908.00",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "平台收取比例：",
                                  detail: "10%",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "平台费：",
                                  detail: "195.00",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "经纪人收取比例：",
                                  detail: "15%",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "经纪人介绍费：",
                                  detail: "299.57",
                                ),
                                _buildDownTitleSpaceBetweenWidget(
                                  title: "实收金额：",
                                  detail: "300.00",
                                  detailColor: AppColor.textYellow,
                                  detailSize: 16.rpx,
                                ),
                                SizedBox(height: 16.rpx),
                              ],
                            ),
                            Text(
                              "保证金将在订单完成后原账户退回",
                              style: AppTextStyle.st
                                  .size(12.rpx)
                                  .textColor(AppColor.black9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onTapConfirm,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 38.rpx, vertical: 24.rpx),
                      child: CommonGradientButton(
                        text: "指派订单",
                        height: 50.rpx,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TitleSpaceBetweenWidget _buildUpTitleSpaceBetweenWidget({
    required String? title,
    required String? detail,
    Widget? detailLeading,
  }) {
    return TitleSpaceBetweenWidget(
      height: 30.rpx,
      title: title,
      detail: detail,
      detailLeading: detailLeading,
    );
  }

  TitleSpaceBetweenWidget _buildDownTitleSpaceBetweenWidget({
    required String? title,
    required String? detail,
    Color? detailColor,
    Widget? detailLeading,
    double? detailSize,
  }) {
    return TitleSpaceBetweenWidget(
      height: 30.rpx,
      title: title,
      titleColor: AppColor.black9,
      detail: detail,
      detailSize: detailSize,
      detailColor: detailColor ?? AppColor.black3,
      detailLeading: detailLeading,
    );
  }
}
