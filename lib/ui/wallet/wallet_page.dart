import 'package:flutter/cupertino.dart';
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
import 'package:guanjia/ui/wallet/recharge/wallet_recharge_view.dart';
import 'package:guanjia/ui/wallet/record/wallet_record_view.dart';
import 'package:guanjia/ui/wallet/wallet_controller.dart';
import 'package:guanjia/ui/wallet/withdraw/wallet_withdraw_view.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///我的钱包
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
                "assets/images/wallet/ic_order_list.png",
                size: 24.rpx,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildTopBackground(),
          Column(
            children: [
              _buildCard(),
              _buildOperationWidget(),
              Expanded(child: _buildTabBarView()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBackground() {
    return Container(
      height: 274.rpx,
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
      margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 36.rpx),
      padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 24.rpx),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.rpx),
          image: const DecorationImage(
            image: AppAssetImage('assets/images/wallet/wallet_card_bg.png'),
            fit: BoxFit.cover,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前余额【USDT】',
                    style: AppTextStyle.st.medium
                        .size(12.rpx)
                        .textColor(AppColor.blackBlue)
                        .copyWith(height: 1),
                  ),
                  Padding(
                    padding: FEdgeInsets(top: 10.rpx),
                    child: Obx(() {
                      return Text(
                        SS.login.info?.balance.toStringAsTrimZero() ?? '',
                        style: AppTextStyle.st.medium
                            .size(24.rpx)
                            .textColor(AppColor.black3)
                            .copyWith(height: 1),
                      );
                    }),
                  ),
                ],
              ),
              Text(
                S.current.guanJiaWallet,
                style: AppTextStyle.st.bold
                    .size(16.rpx)
                    .textColor(AppColor.primaryBlue)
                    .copyWith(height: 1),
              ),
            ],
          ),
          Container(
            margin: FEdgeInsets(top: 26.rpx),
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
                              S.current.historicalWithdrawal,
                              style: AppTextStyle.st.medium
                                  .size(12.rpx)
                                  .textColor(AppColor.black9)
                                  .copyWith(height: 1),
                            ),
                            Text(
                              "5460.00",
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
                              S.current.monthWithdrawal,
                              style: AppTextStyle.st.medium
                                  .size(12.rpx)
                                  .textColor(AppColor.black9)
                                  .copyWith(height: 1),
                            ),
                            Text(
                              "9888.10",
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
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 24.rpx),
      padding: FEdgeInsets(top: 12.rpx, bottom: 16.rpx),
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
      child: AnimatedBuilder(
        animation: controller.tabController,
        builder: (_, child){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(WalletOperationType.values.length, (index) {
              final type = WalletOperationType.valueForIndex(index);
              return _buildOperationButton(
                onTap: () => controller.onTapOperation(type),
                type: type,
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildOperationButton({
    required VoidCallback? onTap,
    required WalletOperationType type,
  }) {
    final String title;
    final String image;
    final bool isSelected = type.index == controller.tabController.index;

    switch (type) {
      case WalletOperationType.recharge:
        title = S.current.topUp;
        image = isSelected
            ? "assets/images/wallet/top_up_select.png"
            : "assets/images/wallet/top_up_normal.png";
        break;
      case WalletOperationType.withdrawal:
        title = S.current.withdrawal;
        image = isSelected
            ? "assets/images/wallet/withdrawal_select.png"
            : "assets/images/wallet/withdrawal_normal.png";
        break;
      case WalletOperationType.record:
        title = S.current.record;
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
        children: [
          AppImage.asset(
            image,
            size: 60.rpx,
          ),
          Padding(
            padding: FEdgeInsets(top: 4.rpx),
            child: Text(
              title,
              style: AppTextStyle.st
                  .size(14.rpx)
                  .textColor(AppColor.black6)
                  .copyWith(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        WalletRechargeView(),
        WalletWithdrawView(),
        WalletRecordView(),
      ],
    );
  }
}
