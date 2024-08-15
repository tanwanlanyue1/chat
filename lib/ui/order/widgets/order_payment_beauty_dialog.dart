import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///佳丽缴纳保证金对话框
class OrderPaymentBeautyDialog extends StatelessWidget {

  final OrderItemModel order;
  const OrderPaymentBeautyDialog._({super.key, required this.order});

  ///- return true 跳转缴纳
  static Future<bool?> show({required OrderItemModel order}){
    return Get.dialog<bool>(
      OrderPaymentBeautyDialog._(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: Text(
                "请先缴纳保证金${order.deposit.toStringAsTrimZero()}元，点击下方按钮立即缴纳！",
                textAlign: TextAlign.center,
                style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
              ),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: Text(
                "注：保证金在订单结束后将会原路退回。",
                style: AppTextStyle.fs12m.copyWith(
                  color: AppColor.gray9,
                  height: 18 / 12,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "去支付",
                onTap: (){
                  Get.back(result: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
