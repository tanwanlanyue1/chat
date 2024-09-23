import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

import 'order_payment_controller.dart';

class OrderPaymentPage extends GetView<OrderPaymentController> {
  const OrderPaymentPage({
    super.key,
    required this.orderId,
    this.type = OrderPaymentType.dating,
  });

  final String orderId;
  final OrderPaymentType type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderPaymentController>(
      init: OrderPaymentController(orderId, type: type),
      builder: (controller) {
        final state = Get.find<OrderPaymentController>().state;

        return Scaffold(
          appBar: AppBar(
            title: Text(S.current.payForTheOrder),
          ),
          body: ListView(
            padding: EdgeInsets.only(
                top: 16.rpx, bottom: Get.mediaQuery.padding.bottom + 16.rpx),
            children: [
              type == OrderPaymentType.dating ? _datingTop() : _vipTop(),
              Container(
                margin: EdgeInsets.only(top: 36.rpx),
                color: Colors.white,
                child: Obx(() {
                  return Column(
                    children: List.generate(state.list.length, (index) {
                      final item = state.list[index];

                      return GestureDetector(
                        onTap: () => controller.onTapPaymentType(index),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 72.rpx,
                          padding:
                              EdgeInsets.all(16.rpx).copyWith(right: 24.rpx),
                          child: Row(
                            children: [
                              Container(
                                width: 40.rpx,
                                height: 40.rpx,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 16.rpx),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: AppTextStyle.st.medium
                                          .size(14.rpx)
                                          .textColor(AppColor.black3)
                                          .textHeight(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10.rpx),
                                    Text(
                                      item.detail ?? "",
                                      style: AppTextStyle.st
                                          .size(12.rpx)
                                          .textColor(AppColor.black9)
                                          .textHeight(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.rpx),
                              AppImage.asset(
                                state.selectIndex.value == index
                                    ? "assets/images/order/choose_select.png"
                                    : "assets/images/order/choose_normal.png",
                                length: 24.rpx,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
              Builder(builder: (context) {
                final num result;

                if (type == OrderPaymentType.dating) {
                  final isRequest =
                      state.datingModel.value?.requestId == SS.login.userId;
                  final deposit = state.datingModel.value?.deposit ?? 0;
                  final serviceCharge =
                      state.datingModel.value?.serviceCharge ?? 0;
                  result = isRequest ? deposit + serviceCharge : deposit;
                } else {
                  result = state.vipModel.value?.amount ?? 0;
                }

                return Button(
                  onPressed: () =>
                      controller.onTapOrderPayment(int.tryParse(orderId) ?? 0),
                  margin: EdgeInsets.symmetric(horizontal: 22.rpx)
                      .copyWith(top: 60.rpx),
                  child: Text(
                    "${S.current.firmPayment} ¥$result",
                    style: TextStyle(color: Colors.white, fontSize: 16.rpx),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _vipTop() {
    return Container(
      height: 92.rpx,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 24.rpx),
          Text(
            S.current.topUpVIPMembership,
            style: AppTextStyle.st
                .size(16.rpx)
                .textColor(AppColor.blackBlue)
                .textHeight(1),
          ),
          SizedBox(height: 16.rpx),
          Text(
            "(${controller.state.vipModel.value?.skuId})",
            style: AppTextStyle.st
                .size(12.rpx)
                .textColor(AppColor.blackBlue)
                .textHeight(1),
          ),
        ],
      ),
    );
  }

  Widget _datingTop() {
    final isRequest =
        controller.state.datingModel.value?.requestId == SS.login.userId;
    return Container(
      height: 128.rpx,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 24.rpx),
          Text(
            isRequest ? S.current.payServiceFeeSecurityDeposit : S.current.payDeposit,
            style: AppTextStyle.st
                .size(16.rpx)
                .textColor(AppColor.blackBlue)
                .textHeight(1),
          ),
          SizedBox(height: 16.rpx),
          Text(
            S.current.remainingTimePaid,
            style: AppTextStyle.st
                .size(12.rpx)
                .textColor(AppColor.blackBlue)
                .textHeight(1),
          ),
          SizedBox(height: 16.rpx),
          countDownWidget(),
        ],
      ),
    );
  }

  Widget countDownWidget() {
    Widget itemWidget(String time) {
      return Container(
        width: 20.rpx,
        height: 20.rpx,
        decoration: BoxDecoration(
          color: AppColor.gradientBegin,
          borderRadius: BorderRadius.circular(2.rpx),
        ),
        alignment: Alignment.center,
        child: Text(time,
            style: AppTextStyle.st.medium.size(12.rpx).textColor(Colors.white)),
      );
    }

    return Obx(() {
      final timeStr = CommonUtils.convertCountdownToHMS(
          controller.state.countDown.value,
          hasHours: false);

      if (timeStr.length < 5) {
        return const SizedBox();
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          itemWidget(timeStr[0]),
          SizedBox(width: 8.rpx),
          itemWidget(timeStr[1]),
          SizedBox(
            width: 18.rpx,
            child: Column(
              children: [
                Container(
                  width: 2.rpx,
                  height: 2.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.black6,
                    borderRadius: BorderRadius.circular(1.rpx),
                  ),
                ),
                SizedBox(height: 6.rpx),
                Container(
                  width: 2.rpx,
                  height: 2.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.black6,
                    borderRadius: BorderRadius.circular(1.rpx),
                  ),
                ),
              ],
            ),
          ),
          itemWidget(timeStr[3]),
          SizedBox(width: 8.rpx),
          itemWidget(timeStr[4]),
        ],
      );
    });
  }
}
