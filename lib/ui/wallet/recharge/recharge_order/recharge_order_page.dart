import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'recharge_order_controller.dart';

///充值订单详情
class RechargeOrderPage extends GetView<RechargeOrderController> {
  late final state = controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.topUp),
      ),
      body: Obx((){
        final desc = state.descRx;
        final orderStatus = state.orderStatusRx;
        final order = state.orderRx();
        if(order == null){
          return Spacing.blank;
        }

        return ListView(
          padding: FEdgeInsets(horizontal: 16.rpx, vertical: 12.rpx),
          children: [
            Text(
              S.current.transferHint,
              textAlign: TextAlign.center,
              style: AppTextStyle.fs14.copyWith(
                color: AppColor.black3,
              ),
            ),
            buildAmount(order.payAmount),
            buildAddress(order.collectionAddress),
            buildQrCode(order),
            buildCountdown(order),
            Divider(height: 32.rpx),
            if(desc.isNotEmpty) buildDesc(desc),
            if(controller.fromRechargePage) Button.outlineStadium(
              margin: FEdgeInsets(horizontal: 22.rpx, top: 16.rpx),
              onPressed: () {
                Get.toNamed(AppRoutes.walletOrderListPage);
              },
              height: 46.rpx,
              borderColor: AppColor.black999,
              child: Text(
                S.current.checkOrder,
                style: AppTextStyle.fs14.copyWith(color: AppColor.black6),
              ),
            ),
            if(orderStatus?.isPending == true) Button.stadium(
              margin: FEdgeInsets(horizontal: 22.rpx, top: 16.rpx),
              onPressed: controller.onTapComplete,
              height: 46.rpx,
              child: Text(
                S.current.transferCompleted,
                style: AppTextStyle.fs14,
              ),
            ),
          ],
        );
      }),
    );
  }

  ///金额
  Widget buildAmount(String amountText) {
    return Container(
      margin: FEdgeInsets(top: 12.rpx, bottom: 16.rpx),
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: amountText.copy,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountText,
              style: AppTextStyle.bold.copyWith(
                fontSize: 26.rpx,
                color: AppColor.black3,
                height: 1.0,
              ),
            ),
            Padding(
              padding: FEdgeInsets(left: 4.rpx),
              child: Text(
                'USDT',
                style: AppTextStyle.fs16.copyWith(
                  color: AppColor.black3,
                  height: 1.2,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(left: 6.rpx, bottom: 8.rpx),
              child: AppImage.asset(
                'assets/images/wallet/ic_copy_mini.png',
                size: 12.rpx,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///地址
  Widget buildAddress(String address) {
    return GestureDetector(
      onTap: address.copy,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46.rpx,
              margin: FEdgeInsets(right: 8.rpx),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.rpx),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                address,
                style: AppTextStyle.fs14.copyWith(
                  color: AppColor.black3,
                ),
              ),
            ),
          ),
          AppImage.asset(
            'assets/images/wallet/ic_copy_mini.png',
            size: 12.rpx,
          ),
        ],
      ),
    );
  }

  ///二维码
  Widget buildQrCode(PaymentOrderModel order) {
    return Center(
      child: Container(
        width: 170.rpx,
        height: 170.rpx,
        margin: FEdgeInsets(top: 12.rpx),
        padding: FEdgeInsets(all: 10.rpx),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.black999.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              padding: FEdgeInsets(all: 4.rpx),
              child: PrettyQrView.data(
                data: order.collectionAddress,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(roundFactor: 0),
                  background: Colors.white,
                ),
              ),
            ),
            //超时
            if (state.orderStatusRx?.isExpired == true)
              Container(
                color: Colors.white.withOpacity(0.7),
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFEBEBEB),
                  padding: FEdgeInsets(vertical: 5.rpx),
                  child: Text(
                    S.current.transferTimeout,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs14m.copyWith(
                      color: AppColor.red,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            //完成
            if (state.orderStatusRx?.isSuccess == true)
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: 46.rpx,
                  color: AppColor.babyBlueButton,
                  alignment: Alignment.center,
                  child: Text(
                    S.current.transactionCompleted,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs14m.copyWith(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ///倒计时
  Widget buildCountdown(PaymentOrderModel order) {
    if(state.orderStatusRx?.isSuccess == true) {
      return Spacing.h(46);
    }

    buildItem({required String label, required String value, Color? color}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: FEdgeInsets(bottom: 4.rpx),
            width: 40.rpx,
            height: 20.rpx,
            alignment: Alignment.center,
            // color: Colors.red,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyle.fs18m.copyWith(
                color: color ?? AppColor.black3,
                height: 1.0,
              ),
            ),
          ),
          Text(
            label,
            style: AppTextStyle.fs12r.copyWith(
              color: color ?? AppColor.black3,
              height: 1.0,
            ),
          ),
        ],
      );
    }

    return Container(
      alignment: Alignment.center,
      margin: FEdgeInsets(top: 10.rpx),
      child: CountdownBuilder(
        endTime: order.timeout.dateTime,
        onFinish: controller.onExpired,
        builder: (duration, text) {
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          final textColor = state.orderStatusRx?.isExpired == true ? AppColor.red : null;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildItem(
                label: S.current.hour,
                value: hours,
                color: textColor,
              ),
              buildItem(
                label: S.current.minute,
                value: minutes,
                color: textColor,
              ),
              buildItem(
                label: S.current.second,
                value: seconds,
                color: textColor,
              ),
            ]
                .separated(
                  Container(
                    width: 20.rpx,
                    height: 20.rpx,
                    alignment: Alignment.center,
                    padding: FEdgeInsets(bottom: 2.rpx),
                    child: Text(
                      ':',
                      style: AppTextStyle.fs18m.copyWith(
                        color: textColor ?? AppColor.black3,
                        height: 1.0,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }

  Widget buildDesc(String text) {
    return HighlightText(
      text,
      style: AppTextStyle.fs14.copyWith(
        color: AppColor.black6,
        height: 1.5,
      ),
      highlightStyle: AppTextStyle.fs14.copyWith(
        color: AppColor.primaryBlue,
        height: 1.5,
      ),
    );
  }
}
