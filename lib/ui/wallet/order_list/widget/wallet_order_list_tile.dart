import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/order_list/wallet_order_list_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class WalletOrderListTile extends StatelessWidget {
  final VoidCallback? onTap;

  ///1充值，2提现
  final int type;

  final WalletOrderItem item;

  const WalletOrderListTile({super.key, this.onTap, required this.type, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: FEdgeInsets(all: 16.rpx),
            child: DefaultTextStyle(
              style: AppTextStyle.fs14.copyWith(
                color: AppColor.black6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildTypeFlag(),
                  Text('${S.current.orderReference}${item.orderNo}'),
                  Text('${S.current.orderAmount}${item.amount}'),
                  Text('${isRecharge ? S.current.rechargeCoinType : S.current.withdrawCoinType}USDT'),
                  if(!isRecharge) Text(S.current.walletAddress(item.address)),
                  Text('${S.current.orderTime}${item.createTime}'),
                ].separated(Spacing.h8).toList(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: buildOrderStatus(),
          ),
          Positioned(
            bottom: 16.rpx,
            right: 16.rpx,
            child: buildCustomService(),
          ),
        ],
      ),
    );
  }

  bool get isRecharge => type == 1;

  Widget buildTypeFlag() {
    return Container(
      width: 60.rpx,
      height: 24.rpx,
      margin: FEdgeInsets(bottom: 4.rpx),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: isRecharge
            ? AppColor.blue6.withOpacity(0.2)
            : AppColor.orange6.withOpacity(0.2),
      ),
      child: Text(
        isRecharge ? S.current.topUp : S.current.withdrawal,
        style: AppTextStyle.fs14.copyWith(
          color: isRecharge ? AppColor.primaryBlue : AppColor.orange6,
        ),
      ),
    );
  }

  Widget buildCustomService() {
    return Button(
      onPressed: () {
        Get.toNamed(AppRoutes.mineFeedbackPage);
      },
      width: 60.rpx,
      height: 26.rpx,
      borderRadius: BorderRadius.circular(4.rpx),
      child: Text(S.current.contactCustomerService, style: AppTextStyle.fs12),
    );
  }

  Widget buildOrderStatus() {
    final icons = {
      0: 'assets/images/wallet/ic_order_pending.png',
      1: 'assets/images/wallet/ic_order_success.png',
      2: 'assets/images/wallet/ic_order_fail.png',
    };
    if(!isRecharge){
      icons[0] = 'assets/images/wallet/ic_order_review.png';
    }

    if(icons[item.status] == null){
      return Spacing.blank;
    }
    return AppImage.asset(
      icons[item.status] ?? '',
      width: 56.rpx,
      height: 56.rpx,
    );
  }
}
