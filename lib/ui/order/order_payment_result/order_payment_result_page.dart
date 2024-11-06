import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import '../../../common/network/api/model/user/vip_model.dart';
import 'order_payment_result_controller.dart';

class OrderPaymentResultPage extends GetView<OrderPaymentResultController> {
  const OrderPaymentResultPage({
    super.key,
    required this.orderId,
    required this.type,
    required this.isSuccess,
    this.vipPackage,
    this.vipOrderNo = '',
  });

  final int orderId;

  final OrderPaymentType type;
  final bool isSuccess;
  final VipPackageModel? vipPackage;
  ///vip订单编号
  final String vipOrderNo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderPaymentResultController>(
      init: OrderPaymentResultController(
        orderId,
        type: type,
        vipPackage: vipPackage,
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              isSuccess ? S.current.paymentSuccess : S.current.paymentFail,
            ),
          ),
          body: isSuccess ? _buildSuccess() : _buildFail(),
        );
      },
    );
  }

  ListView _buildSuccess() {
    final state = controller.state;

    final String title;
    final String orderNumber;
    num result = 0;
    final String remark;
    if (type == OrderPaymentType.dating) {
      final isRequest = state.detailModel.value?.requestId == SS.login.userId;

      title = isRequest
          ? S.current.serviceFeePaidSuccessfully
          : S.current.marginPaymentSuccessful;

      orderNumber = state.detailModel.value?.number ?? "";

      final deposit = state.detailModel.value?.deposit ?? 0;
      final serviceCharge = state.detailModel.value?.serviceCharge ?? 0;
      result = isRequest ? deposit + serviceCharge : deposit;
      remark = S.current.beReturnedWithin24Hours;
    } else {
      title = S.current.VIPRechargeSuccess;
      orderNumber = vipOrderNo;
      final vipPackage = this.vipPackage;
      if(vipPackage != null){
        result = vipPackage.discountPrice > 0 ? vipPackage.discountPrice : vipPackage.price;
      }
      remark = S.current.enjoyNumberOfVIPRights;
    }

    return ListView(
      children: [
        SizedBox(height: 36.rpx),
        AppImage.asset(
          "assets/images/order/success.png",
          size: 70.rpx,
        ),
        SizedBox(height: 24.rpx),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.st
              .size(16.rpx)
              .textColor(AppColor.blackBlue)
              .textHeight(1),
        ),
        SizedBox(height: 24.rpx),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(orderNumber.isNotEmpty) Text(
                "${S.current.orderReference}$orderNumber",
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              SizedBox(height: 14.rpx),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: S.current.orderAmount,
                    ),
                    TextSpan(
                        text: result.toCurrencyString(),
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
                S.current.modeOfPayment,
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
                remark,
                style: AppTextStyle.st
                    .size(14.rpx)
                    .textColor(AppColor.black6)
                    .textHeight(1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.rpx)
                    .copyWith(top: 60.rpx),
                child: type == OrderPaymentType.dating
                    ? GestureDetector(
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
                            S.current.checkOrder,
                            style: AppTextStyle.st
                                .size(16.rpx)
                                .textColor(AppColor.black9)
                                .textHeight(1),
                          ),
                        ),
                      )
                    : Button(
                        onPressed: Get.back,
                        child: Text(
                          S.current.enjoyVIPRightsNow,
                          style: AppTextStyle.st
                              .size(16.rpx)
                              .textColor(Colors.white),
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
          size: 70.rpx,
        ),
        SizedBox(height: 24.rpx),
        Text(
          S.current.paymentFail,
          textAlign: TextAlign.center,
          style: AppTextStyle.st
              .size(16.rpx)
              .textColor(AppColor.blackBlue)
              .textHeight(1),
        ),
        SizedBox(height: 16.rpx),
        Text(
          S.current.backViewOrder,
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
            S.current.payAgain,
            style: AppTextStyle.st.size(16.rpx).textColor(Colors.white),
          ),
        ),
      ],
    );
  }
}
