import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'transfer_money_controller.dart';

///转账
class TransferMoneyPage extends GetView<TransferMoneyController> {
  const TransferMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('转账'),
      ),
      body: ListView(
        children: [
          Container(
            padding: FEdgeInsets(top: 32.rpx),
            alignment: Alignment.center,
            child: ChatAvatar.circle(
              userId: controller.userId.toString(),
              width: 50.rpx,
              height: 50.rpx,
            ),
          ),
          ChatUserBuilder(
            userId: controller.userId.toString(),
            builder: (user) {
              return Padding(
                padding: FEdgeInsets(top: 8.rpx, bottom: 32.rpx),
                child: Text(
                  user?.baseInfo.userName ?? '',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.fs16b.copyWith(
                    color: AppColor.gray5,
                    height: 1.0001,
                  ),
                ),
              );
            },
          ),
          buildAmountInput(),
        ],
      ),
    );
  }

  Widget buildAmountInput() {
    return TextField(
      controller: controller.amountEditingController,
      textAlign: TextAlign.end,
      maxLines: 1,
      onSubmitted: (value){
        controller.submit();
      },
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
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
              child: Text('金额'),
            ),
          ],
        ),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Text('元'),
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
        inputFormatters: [LengthLimitingTextInputFormatter(120)],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          hintStyle: const TextStyle(color: AppColor.gray9),
          hintText: '最懂你的管佳（红包文字可输入）',
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
              text: '¥',
              style: AppTextStyle.fs20b.copyWith(color: AppColor.gray5),
              children: [
                TextSpan(text: amount, style: TextStyle(fontSize: 40.rpx)),
              ]),
        );
      }),
    );
  }
}
