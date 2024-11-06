import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_order_list_view.dart';

///充值提现订单列表
class WalletOrderListPage extends StatelessWidget {
  final int tabIndex;
  const WalletOrderListPage({this.tabIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton.light(),
          backgroundColor: AppColor.primaryBlue,
          title: Text(S.current.orderList),
          titleTextStyle: AppTextStyle.fs18m.copyWith(color: Colors.white),
          systemOverlayStyle: SystemUI.lightStyle,
        ),
        body: Column(
          children: [
            buildTabBar(),
            const Expanded(
              child: TabBarView(
                children: [
                  WalletOrderListView(key: Key('recharge'), type: 1),
                  WalletOrderListView(key: Key('withdraw'), type: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      color: Colors.white,
      margin: const FEdgeInsets(bottom: 1),
      child: TabBar(
        labelStyle: AppTextStyle.fs16m,
        labelColor: AppColor.primaryBlue,
        unselectedLabelStyle: AppTextStyle.fs16,
        unselectedLabelColor: AppColor.black3,
        indicatorColor: AppColor.primaryBlue,
        indicatorWeight: 3.rpx,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            height: 48.rpx,
            child: Padding(
              padding: FEdgeInsets(horizontal: 24.rpx),
              child: Text(S.current.topUp),
            ),
          ),
          Tab(
            height: 48.rpx,
            child: Padding(
              padding: FEdgeInsets(horizontal: 24.rpx),
              child: Text(S.current.withdrawal),
            ),
          ),
        ],
      ),
    );
  }
}
