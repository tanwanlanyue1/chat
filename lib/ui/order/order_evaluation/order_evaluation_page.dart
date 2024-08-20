import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/label_widget.dart';

import 'order_evaluation_controller.dart';

class OrderEvaluationPage extends StatelessWidget {
  OrderEvaluationPage({super.key});

  final controller = Get.put(OrderEvaluationController());
  final state = Get.find<OrderEvaluationController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('评价'),
      ),
      body: Obx(() {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: AppImage.asset(
                "assets/images/order/evaluation_bg.png",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(
                top: 36.rpx,
                bottom: 30.rpx + Get.mediaQuery.padding.bottom,
              ),
              child: Column(
                children: [
                  Text(
                    "本次订单已完成",
                    style: AppTextStyle.st.medium
                        .size(20.rpx)
                        .textColor(AppColor.black3)
                        .textHeight(1),
                  ),
                  SizedBox(height: 12.rpx),
                  Text(
                    "请对该位佳丽进行评价",
                    style: AppTextStyle.st.medium
                        .size(14.rpx)
                        .textColor(AppColor.black6)
                        .textHeight(1),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24.rpx),
                    width: double.infinity,
                    child: Wrap(
                      spacing: 12.rpx,
                      runSpacing: 12.rpx,
                      children: List.generate(state.labelItems.length, (index) {
                        return GetBuilder<OrderEvaluationController>(
                            builder: (controller) {
                          final item = state.labelItems[index];
                          return LabelWidget(
                            onTap: () => controller.onTapLabel(item),
                            item: item,
                            selectedBackgroundColor: AppColor.primary,
                            selectedTextColor: Colors.white,
                            backgroundColor: Colors.white,
                            borderColor: Colors.transparent,
                            textColor: AppColor.black3,
                          );
                        });
                      }),
                    ),
                  ),
                  _buildSubTitle("服务态度"),
                  Container(
                    margin: EdgeInsets.only(top: 16.rpx),
                    height: 50.rpx,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: Wrap(
                      spacing: 16.rpx,
                      children: List.generate(5, (index) {
                        final isSelected = index + 1 <= state.starIndex.value;

                        return GestureDetector(
                          onTap: () => controller.onTapStar(index + 1),
                          child: AppImage.asset(
                            isSelected
                                ? "assets/images/order/star_select.png"
                                : "assets/images/order/star_normal.png",
                            length: 36.rpx,
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 24.rpx),
                  _buildSubTitle("其他建议"),
                  Container(
                    height: 150.rpx,
                    margin: EdgeInsets.only(top: 16.rpx),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.rpx, vertical: 12.rpx),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: InputWidget(
                      hintText: "请填写对该位佳丽的建议",
                      // hintText: S.current.userSignatureHint,
                      maxLength: 200,
                      lines: 100,
                      fillColor: Colors.transparent,
                      inputController: controller.otherController,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Button(
                    height: 50.rpx,
                    onPressed: controller.onTapSubmit,
                    margin: EdgeInsets.symmetric(horizontal: 22.rpx)
                        .copyWith(top: 22.rpx),
                    child: Text(
                      "提交",
                      style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSubTitle(String title) {
    return Row(
      children: [
        SizedBox(
          width: 4.rpx,
          height: 20.rpx,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(2.rpx),
            ),
          ),
        ),
        SizedBox(width: 8.rpx),
        Text(
          title,
          style: AppTextStyle.st.medium.size(16.rpx).textColor(AppColor.black3),
        ),
      ],
    );
  }
}
