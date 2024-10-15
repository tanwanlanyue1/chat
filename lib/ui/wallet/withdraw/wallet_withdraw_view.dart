import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wallet/withdraw/wallet_address_popup_menu_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_withdraw_controller.dart';

///提现
class WalletWithdrawView extends StatefulWidget {
  const WalletWithdrawView({super.key});

  @override
  State<WalletWithdrawView> createState() => _WalletWithdrawViewState();
}

class _WalletWithdrawViewState extends State<WalletWithdrawView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(WalletWithdrawController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final addressList = controller.addressListRx();
      final address = controller.addressRx();

      return ListView(
        padding: FEdgeInsets(
          horizontal: 16.rpx,
          top: 24.rpx,
          bottom: Get.mediaQuery.padding.bottom + 24.rpx,
        ),
        children: [
          Row(
            children: [
              Container(
                width: 4.rpx,
                height: 20.rpx,
                margin: EdgeInsets.only(right: 8.rpx),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(2.rpx),
                ),
              ),
              Text(
                '提现到：',
                style: AppTextStyle.st.medium
                    .size(16.rpx)
                    .textColor(AppColor.black6),
              ),
            ],
          ),
          Padding(
            padding: FEdgeInsets(top: 16.rpx),
            child: WalletAddressPopupMenuButton(
              addressList: addressList,
              address: address,
              onChanged: controller.addressRx.call,
              onTapAdd: controller.onTapAddAddress,
              onTapDelete: controller.onTapDeleteAddress,
            ),
          ),
          buildAmount(),
          Padding(
            padding: FEdgeInsets(top: 8.rpx, left: 8.rpx),
            child: Text(
              '手续费：2 USDT',
              style: AppTextStyle.fs12r.copyWith(
                color: AppColor.black999,
                height: 1,
              ),
            ),
          ),
          buildDesc(),
          Padding(
            padding: FEdgeInsets(top: 36.rpx, horizontal: 20.rpx),
            child: CommonGradientButton(
              onTap: controller.onSubmit,
              height: 50.rpx,
              text: '立即提现',
            ),
          ),
        ],
      );
    });
  }

  Widget buildAmount() {
    return Container(
      margin: FEdgeInsets(top: 16.rpx),
      padding: FEdgeInsets(horizontal: 12.rpx),
      decoration: BoxDecoration(
        color: AppColor.grayBackground,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: DefaultTextStyle(
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.black3,
        ),
        child: Row(
          children: [
            Text(
              '提现金额：',
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black6,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller.amountEditingController,
                style: AppTextStyle.fs14b.copyWith(
                  color: AppColor.black3,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                inputFormatters: [
                  DecimalTextInputFormatter(
                    maxValue: SS.appConfig.transferMaxAmount,
                    maxValueHint:
                        '金额不能超过${SS.appConfig.transferMaxAmount.toStringAsTrimZero()}',
                    decimalDigits: SS.appConfig.decimalDigits,
                  )
                ],
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: FEdgeInsets(),
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(left: 8.rpx),
              child: const Text('USDT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesc() {
    return Container(
      margin: FEdgeInsets(top: 12.rpx),
      padding: FEdgeInsets(all: 12.rpx),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: Text.rich(TextSpan(
        style: AppTextStyle.fs12m.copyWith(
          color: AppColor.black999,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: '提现须知\n',
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.black6,
            ),
          ),
          const TextSpan(text: '支持金额：最低提现额度'),
          TextSpan(
            text: ' 2 ',
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.red,
            ),
          ),
          const TextSpan(text: 'USDT；\n'),
          const TextSpan(text: '提现限额：您的24h提现额度为'),
          TextSpan(
            text: ' 9999999 ',
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.red,
            ),
          ),
          const TextSpan(text: 'USDT；\n'),
          const TextSpan(text: '提现手续费：'),
          TextSpan(
            text: '10-20 ',
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.red,
            ),
          ),
          const TextSpan(text: 'USDT。'),
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
