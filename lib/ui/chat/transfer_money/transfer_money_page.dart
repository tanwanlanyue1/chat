import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'transfer_money_controller.dart';
import 'widgets/transfer_money_keybaord.dart';

///转账
class TransferMoneyPage extends GetView<TransferMoneyController> {
  const TransferMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 不要让全局隐藏键盘影响
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('转账'),
        ),
        body: Column(
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
                      color: AppColor.blackBlue,
                      height: 1.0001,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: Container(
                padding: FEdgeInsets(all: 24.rpx),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.rpx)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '转账金额',
                      style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),
                    ),
                    buildAmountInput(),
                  ],
                ),
              ),
            ),
            TransferMoneyKeyboard(
              formatter: DecimalTextInputFormatter(
                decimalDigits: SS.appConfig.decimalDigits,
                maxValue: SS.appConfig.transferMaxAmount,
                maxValueHint:
                    '转账金额不能大于${SS.appConfig.transferMaxAmount.toCurrencyString()}',
              ),
              onChanged: (value) {
                controller.amountEditingController.text = value;
              },
              onConfirm: (value) => controller.submit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAmountInput() {
    final style = PFTextStyle(
      fontSize: 40.rpx,
      color: AppColor.blackBlue,
      fontWeight: FontWeight.bold,
    );
    const border = UnderlineInputBorder(
      borderSide: BorderSide(color: AppColor.scaffoldBackground),
    );
    return Padding(
      padding: EdgeInsets.only(top: 8.rpx),
      child: TextField(
        focusNode: controller.focusNode,
        controller: controller.amountEditingController,
        maxLines: 1,
        style: style,
        cursorColor: AppColor.primaryBlue,
        decoration: InputDecoration(
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          hintStyle: const TextStyle(color: AppColor.gray9),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: FEdgeInsets(right: 16.rpx),
                child: Text(
                  SS.appConfig.currencyUnit,
                  style: style,
                ),
              ),
            ],
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
