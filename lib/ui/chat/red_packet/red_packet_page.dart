import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'red_packet_controller.dart';

///发红包
class RedPacketPage extends GetView<RedPacketController> {
  const RedPacketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.current.giveRedEnvelopes),
      ),
      body: Stack(
        children: [
          buildBackground(),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Positioned.fill(
      child: AppImage.asset(
        'assets/images/chat/chat_bg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildBody() {
    return DefaultTextStyle(
      style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue),
      child: ListView(
        padding: FEdgeInsets(all: 24.rpx),
        children: [
          buildAmountInput(),
          buildDescInput(),
          buildAmountText(),
          CommonGradientButton(
            height: 50.rpx,
            text: S.current.stuffMoneyIntoRedEnvelopes,
            onTap: controller.sendRedPacket,
          ),
        ],
      ),
    );
  }

  Widget buildAmountInput() {
    return TextField(
      controller: controller.amountEditingController,
      textAlign: TextAlign.end,
      maxLines: 1,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue),
      inputFormatters: [
        DecimalTextInputFormatter(
          maxValue: SS.appConfig.redPacketMaxAmount,
          maxValueHint: '${S.current.theMaximumAmountCannotExceed}${SS.appConfig.redPacketMaxAmount.toCurrencyString()}',
          decimalDigits: SS.appConfig.decimalDigits,
        ),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        hintStyle: const TextStyle(color: AppColor.gray9),
        hintText: '0.00',
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: FEdgeInsets(left: 16.rpx),
              child: Text(S.current.amount),
            ),
          ],
        ),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Text(SS.appConfig.currencyUnit),
            ),
          ],
        ),
        prefixIconConstraints: BoxConstraints(minHeight: 54.rpx),
        suffixIconConstraints: BoxConstraints(minHeight: 54.rpx),
        constraints: BoxConstraints(minHeight: 54.rpx),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget buildDescInput() {
    return Padding(
      padding: FEdgeInsets(top: 16.rpx),
      child: TextField(
        controller: controller.descEditingController,
        maxLines: 1,
        inputFormatters: [
          LengthLimitingTextInputFormatter(SS.appConfig.redPacketDescLimit)
        ],
        style: AppTextStyle.fs14m.copyWith(color: AppColor.blackBlue),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          hintStyle: AppTextStyle.fs14.copyWith(color: AppColor.black999),
          hintText: '${controller.defaultDesc}（${S.current.redEnvelopeTextEntered}）',
          prefixIcon: SizedBox(width: 16.rpx),
          prefixIconConstraints: BoxConstraints(minHeight: 54.rpx),
          constraints: BoxConstraints(minHeight: 54.rpx),
          contentPadding: FEdgeInsets(horizontal: 16.rpx),
        ),
      ),
    );
  }

  Widget buildAmountText() {
    return Padding(
      padding: FEdgeInsets(top: 36.rpx, bottom: 100.rpx),
      child: Obx(() {
        var amount = controller.state.amountRx();
        if (amount.isEmpty) {
          amount = '0.00';
        }
        return Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: SS.appConfig.currencyUnit,
              style: AppTextStyle.fs20m.copyWith(color: AppColor.gray5),
              children: [
                TextSpan(
                  text: amount,
                  style: TextStyle(fontSize: 40.rpx),
                ),
              ]),
        );
      }),
    );
  }
}
