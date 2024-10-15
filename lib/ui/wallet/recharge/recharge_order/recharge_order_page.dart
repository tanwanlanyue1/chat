import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'recharge_order_controller.dart';
import 'recharge_order_state.dart';

///充值订单详情
class RechargeOrderPage extends StatelessWidget {
  final controller = Get.put(RechargeOrderController());
  final state = Get.find<RechargeOrderController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('充值'),
      ),
      body: Obx((){
        final orderStatus = state.orderStatusRx();
        return ListView(
          padding: FEdgeInsets(horizontal: 16.rpx, vertical: 12.rpx),
          children: [
            Text(
              '请使用支持波场网络(tron)的钱包或交易软件进行转账',
              textAlign: TextAlign.center,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black3,
              ),
            ),
            buildAmount(),
            buildAddress(),
            buildQrCode(),
            buildCountdown(),
            Divider(height: 32.rpx),
            buildDesc(),
            Button.outlineStadium(
              margin: FEdgeInsets(horizontal: 22.rpx, top: 16.rpx),
              onPressed: () {},
              height: 46.rpx,
              borderColor: AppColor.black999,
              child: Text(
                '查看订单',
                style: AppTextStyle.fs14m.copyWith(color: AppColor.black6),
              ),
            ),
            if(orderStatus.isPending) Button.stadium(
              margin: FEdgeInsets(horizontal: 22.rpx, top: 16.rpx),
              onPressed: controller.onTapComplete,
              height: 46.rpx,
              child: Text(
                '已完成转账',
                style: AppTextStyle.fs14m,
              ),
            ),
          ],
        );
      }),
    );
  }

  ///金额
  Widget buildAmount() {
    final amount = '133.012';
    return Container(
      margin: FEdgeInsets(top: 12.rpx, bottom: 16.rpx),
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: amount.copy,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: AppTextStyle.fs26b.copyWith(
                color: AppColor.black3,
                height: 1.0,
              ),
            ),
            Padding(
              padding: FEdgeInsets(left: 4.rpx),
              child: Text(
                'USDT',
                style: AppTextStyle.fs16m.copyWith(
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
  Widget buildAddress() {
    final address = 'TAALiTehrjjAwp8oFXddpmUUwc1t5Jz36z';
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
                style: AppTextStyle.fs14m.copyWith(
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
  Widget buildQrCode() {
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
                data: 'TAALiTehrjjAwp8oFXddpmUUwc1t5Jz36z',
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(roundFactor: 0),
                  background: Colors.white,
                ),
              ),
            ),
            //超时
            if (state.orderStatusRx().isExpired)
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
                    '转账超时\n二维码已过期',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs14b.copyWith(
                      color: AppColor.red,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            //完成
            if (state.orderStatusRx().isSuccess)
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
                    '交易已完成',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs14b.copyWith(
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
  Widget buildCountdown() {
    if(state.orderStatusRx().isSuccess) {
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
              style: AppTextStyle.fs18b.copyWith(
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

    final endTime = DateTime.now().add(10.seconds);
    return Container(
      alignment: Alignment.center,
      margin: FEdgeInsets(top: 10.rpx),
      child: CountdownBuilder(
        endTime: endTime,
        onFinish: (){
          if(state.orderStatusRx().isPending){
            state.orderStatusRx.value = RechargeOrderStatus.expired;
          }
        },
        builder: (duration, text) {
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          final textColor = state.orderStatusRx().isExpired? AppColor.red : null;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildItem(
                label: '时',
                value: hours,
                color: textColor,
              ),
              buildItem(
                label: '分',
                value: minutes,
                color: textColor,
              ),
              buildItem(
                label: '秒',
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
                      style: AppTextStyle.fs18b.copyWith(
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

  Widget buildDesc() {
    return Text.rich(TextSpan(
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.black6,
          height: 1.5,
        ),
        children: const [
          TextSpan(text: '①请在'),
          TextSpan(
            text: '15分钟之内完成付款',
            style: TextStyle(color: AppColor.primaryBlue),
          ),
          TextSpan(text: '，超时付款不会到账；\n'),
          TextSpan(text: '②实际转账'),
          TextSpan(
            text: '金额需要与上方显示的订单金额一致',
            style: TextStyle(color: AppColor.primaryBlue),
          ),
          TextSpan(text: '，否则系统不到账;\n'),
          TextSpan(text: '③点击金额和地区区域，可直接复制;\n'),
          TextSpan(text: '④如扫码后无法付款，请直接粘贴地址及金额进行付款作;\n'),
          TextSpan(text: '⑤如出现转账金额与订单金额不一致系统未到账的情况请联系客服人员。'),
        ]));
  }
}
