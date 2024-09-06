import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/enum/wallet_enum.dart';
import 'package:guanjia/ui/wallet/wallet_controller.dart';
import 'package:guanjia/ui/wallet/widgets/wallet_top_up_widget.dart';
import 'package:guanjia/ui/wallet/widgets/wallet_transfer_widget.dart';
import 'package:guanjia/ui/wallet/widgets/wallet_withdrawal_widget.dart';
import 'package:guanjia/widgets/app_image.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final controller = Get.put(WalletController());
  final state = Get.find<WalletController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.myWallet),
        actions: [
          GestureDetector(
            onTap: controller.onTapOrder,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              padding: EdgeInsets.symmetric(horizontal: 10.rpx),
              child: AppImage.asset(
                "assets/images/wallet/order.png",
                length: 24.rpx,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildTopBackground(),
          Obx(() {
            return Column(
              children: [
                _buildCard(),
                _buildOperationWidget(),
                _buildBottom(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopBackground() {
    return Container(
      height: 310.rpx,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.gradientBackgroundBegin,
            AppColor.gradientBackgroundEnd,
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      height: 190.rpx,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 36.rpx),
      padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 24.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44.rpx,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "总共余额",
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.black9)
                          .copyWith(height: 1),
                    ),
                    Obx((){
                      return Text(
                        SS.login.info?.balance.toCurrencyString() ?? '',
                        style: AppTextStyle.st.medium
                            .size(20.rpx)
                            .textColor(AppColor.black3)
                            .copyWith(height: 1),
                      );
                    }),
                  ],
                ),
                Text(
                  "管佳钱包",
                  style: AppTextStyle.st.bold
                      .size(16.rpx)
                      .textColor(AppColor.primary)
                      .copyWith(height: 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.rpx),
          Text(
            "****   ****   ****   5126",
            style: AppTextStyle.st.medium
                .size(16.rpx)
                .textColor(AppColor.black6)
                .copyWith(height: 1),
          ),
          const Spacer(),
          SizedBox(
            height: 34.rpx,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "历史提现",
                              style: AppTextStyle.st.medium
                                  .size(12.rpx)
                                  .textColor(AppColor.black9)
                                  .copyWith(height: 1),
                            ),
                            Text(
                              "￥5460.00",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(AppColor.black3)
                                  .copyWith(height: 1),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 25.rpx,
                        thickness: 1.rpx,
                        indent: 7.rpx,
                        endIndent: 7.rpx,
                        color: AppColor.black9.withOpacity(0.2),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "本月可提现",
                              style: AppTextStyle.st.medium
                                  .size(12.rpx)
                                  .textColor(AppColor.black9)
                                  .copyWith(height: 1),
                            ),
                            Text(
                              "￥9888.10",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(AppColor.black3)
                                  .copyWith(height: 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppImage.asset(
                  "assets/images/wallet/card.png",
                  width: 48.rpx,
                  height: 30.rpx,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationWidget() {
    return Container(
      height: 118.rpx,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 24.rpx),
      padding: EdgeInsets.symmetric(horizontal: 16.rpx)
          .copyWith(top: 16.rpx, bottom: 24.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.rpx,
            offset: Offset(0, 4.rpx),
          ),
        ],
      ),
      child: Row(
        children: List.generate(4, (index) {
          final type = WalletOperationType.valueForIndex(index + 1);
          return _buildOperationButton(
            onTap: () => controller.onTapOperation(type),
            type: type,
          );
        }).separated(const Spacer()).toList(),
      ),
    );
  }

  Widget _buildOperationButton({
    required VoidCallback? onTap,
    required WalletOperationType type,
  }) {
    final String title;
    final String image;
    final bool isSelected = type == state.typeIndex.value;

    switch (type) {
      case WalletOperationType.topUp:
        title = '充值';
        image = isSelected
            ? "assets/images/wallet/top_up_select.png"
            : "assets/images/wallet/top_up_normal.png";
        break;
      case WalletOperationType.transfer:
        title = '转账';
        image = isSelected
            ? "assets/images/wallet/transfer_select.png"
            : "assets/images/wallet/transfer_normal.png";
        break;
      case WalletOperationType.withdrawal:
        title = '提现';
        image = isSelected
            ? "assets/images/wallet/withdrawal_select.png"
            : "assets/images/wallet/withdrawal_normal.png";
        break;
      case WalletOperationType.record:
        title = '记录';
        image = isSelected
            ? "assets/images/wallet/record_select.png"
            : "assets/images/wallet/record_normal.png";
        break;
      default:
        title = '';
        image = '';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppImage.asset(
            image,
            length: 60.rpx,
          ),
          Text(
            title,
            style: AppTextStyle.st
                .size(14.rpx)
                .textColor(AppColor.black3)
                .copyWith(height: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    final Widget widget;

    switch (state.typeIndex.value) {
      case WalletOperationType.normal:
        widget = Container();
        break;
      case WalletOperationType.topUp:
        widget = WalletTopUpWidget();
        break;
      case WalletOperationType.transfer:
        widget = WalletTransferWidget();
        break;
      case WalletOperationType.withdrawal:
        widget = WalletWithdrawalWidget();
        break;
      case WalletOperationType.record:
        widget = Container(color: Colors.purple);
        break;
    }

    return Expanded(
      child: widget,
    );
  }
}
