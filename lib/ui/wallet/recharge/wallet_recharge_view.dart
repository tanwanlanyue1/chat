import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_recharge_controller.dart';

class WalletRechargeView extends StatefulWidget {
  final bool fromRechargePage;
  const WalletRechargeView({super.key, this.fromRechargePage = false});

  @override
  State<WalletRechargeView> createState() => _WalletRechargeViewState();
}

class _WalletRechargeViewState extends State<WalletRechargeView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(WalletRechargeController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fromRechargePage = widget.fromRechargePage;
    return ListView(
      padding: FEdgeInsets(
        horizontal: 16.rpx,
        top: 24.rpx,
        bottom: Get.mediaQuery.padding.bottom + 24.rpx,
      ),
      children: [
        _buildItem(
          title: S.current.rechargeCoinType,
          child: Container(
            alignment: Alignment.center,
            height: 46.rpx,
            margin: fromRechargePage ? FEdgeInsets(horizontal: 16.rpx) : null,
            decoration: BoxDecoration(
              color: AppColor.grayBackground,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: Text(
              'USDT',
              style: AppTextStyle.fs18m.copyWith(
                color: AppColor.black3,
              ),
            ),
          ),
        ),
        Spacing.h24,
        _buildItem(
          title: S.current.rechargeAmount,
          child: Container(
            alignment: Alignment.center,
            height: 46.rpx,
            margin: fromRechargePage ? FEdgeInsets(horizontal: 16.rpx) : null,
            decoration: BoxDecoration(
              color: AppColor.grayBackground,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: TextField(
              controller: controller.amountEditingController,
              expands: true,
              maxLines: null,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black3,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              inputFormatters: [
                DecimalTextInputFormatter(
                  decimalDigits: SS.appConfig.decimalDigits,
                  maxValue: 9999999,
                  maxValueHint: S.current.amountMaxLimitExceed
                )
              ],
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: S.current.rechargeAmountHint,
                hintStyle: AppTextStyle.fs14.copyWith(color: AppColor.black9),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: FEdgeInsets(horizontal: 12.rpx),
              ),
            ),
          ),
        ),
        if(!fromRechargePage) Padding(
          padding: FEdgeInsets(top: 36.rpx, horizontal: 20.rpx),
          child: CommonGradientButton(
            onTap: controller.onSubmit,
            height: 50.rpx,
            text: S.current.gotoRecharge,
          ),
        ),
        if(fromRechargePage) Padding(
          padding: FEdgeInsets(top: 56.rpx, horizontal: 20.rpx),
          child: Button(
            onPressed: controller.onSubmit,
            height: 50.rpx,
            child: Text(S.current.submitOrder),
          ),
        ),
      ],
    );
  }

  Column _buildItem({
    required String title,
    required Widget child,
  }) {
    return Column(
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
              title,
              style: AppTextStyle.st.medium
                  .size(16.rpx)
                  .textColor(AppColor.black6),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.rpx),
          child: child,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
