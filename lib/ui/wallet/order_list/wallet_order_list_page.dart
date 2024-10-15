import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_order_list_view.dart';

///充值提现订单列表
class WalletOrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton.light(),
          backgroundColor: AppColor.primaryBlue,
          title: const Text('订单列表'),
          titleTextStyle: AppTextStyle.fs18b.copyWith(color: Colors.white),
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
      child: TabBar(
        labelStyle: AppTextStyle.fs16b,
        labelColor: AppColor.primaryBlue,
        unselectedLabelStyle: AppTextStyle.fs16m,
        unselectedLabelColor: AppColor.black3,
        indicatorColor: AppColor.primaryBlue,
        indicatorWeight: 3.rpx,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            height: 48.rpx,
            child: Padding(
              padding: FEdgeInsets(horizontal: 24.rpx),
              child: Text('充值'),
            ),
          ),
          Tab(
            height: 48.rpx,
            child: Padding(
              padding: FEdgeInsets(horizontal: 24.rpx),
              child: Text('提现'),
            ),
          ),
        ],
      ),
    );
  }
}
