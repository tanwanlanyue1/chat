import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

import 'order_payment_result_controller.dart';

class OrderPaymentResultPage extends GetView<OrderPaymentResultController> {
  const OrderPaymentResultPage({
    super.key,
    required this.orderId,
    required this.isSuccess,
  });

  final int orderId;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderPaymentResultController>(
      init: OrderPaymentResultController(orderId),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              // isSuccess ? S.current.payment_success : S.current.payment_fail,
              isSuccess ? "支付成功" : "支付失败",
            ),
          ),
          body: isSuccess ? _buildSuccess() : _buildFail(),
        );
      },
    );
  }

  ListView _buildSuccess() {
    final state = controller.state;
    final isRequest = state.detailModel.value?.requestId == SS.login.userId;

    final deposit = state.detailModel.value?.deposit ?? 0;
    final serviceCharge = state.detailModel.value?.serviceCharge ?? 0;
    final result = isRequest ? deposit + serviceCharge : serviceCharge;

    return ListView(
      children: [
        SizedBox(height: 36.rpx),
        AppImage.asset(
          "assets/images/order/success.png",
          length: 70.rpx,
        ),
        SizedBox(height: 24.rpx),
        Text(
          isRequest ? "保证金服务费支付成功！" : "保证金支付成功！",
          textAlign: TextAlign.center,
          style: AppTextStyle.st
              .size(16.rpx)
              .textColor(Colors.black)
              .textHeight(1),
        ),
        SizedBox(height: 24.rpx),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "订单编号：$orderId",
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              SizedBox(height: 14.rpx),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "订单金额：",
                    ),
                    TextSpan(
                        text: "$result元",
                        style: AppTextStyle.st.textColor(AppColor.textRed)),
                  ],
                ),
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              SizedBox(height: 14.rpx),
              Text(
                "支付方式：管佳支付",
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              Divider(
                height: 32.rpx,
                thickness: 1,
                color: AppColor.scaffoldBackground,
              ),
              Text(
                "注：保证金在订单结束后将在24小时内原路返回。",
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              GestureDetector(
                onTap: () => controller.toOrderDetail(orderId),
                child: Container(
                  height: 50.rpx,
                  margin: EdgeInsets.symmetric(horizontal: 22.rpx)
                      .copyWith(top: 60.rpx),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColor.black9,
                    ),
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "查看订单",
                    style: AppTextStyle.st
                        .size(16.rpx)
                        .textColor(AppColor.black9)
                        .textHeight(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView _buildFail() {
    return ListView(
      children: [
        SizedBox(height: 36.rpx),
        AppImage.asset(
          "assets/images/order/fail.png",
          length: 70.rpx,
        ),
        SizedBox(height: 24.rpx),
        Text(
          "支付失败",
          textAlign: TextAlign.center,
          style: AppTextStyle.st
              .size(16.rpx)
              .textColor(Colors.black)
              .textHeight(1),
        ),
        SizedBox(height: 16.rpx),
        Text(
          "返回查看订单",
          textAlign: TextAlign.center,
          style: AppTextStyle.st
              .size(12.rpx)
              .textColor(AppColor.black9)
              .textHeight(1),
        ),
        Button(
          onPressed: Get.back,
          margin:
              EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(top: 60.rpx),
          child: Text(
            "重新支付",
            style: AppTextStyle.st.size(16.rpx).textColor(Colors.white),
          ),
        ),
      ],
    );
  }
}
