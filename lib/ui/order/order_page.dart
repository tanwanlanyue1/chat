import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/order_list/order_list_page.dart';

import 'enum/order_enum.dart';
import 'order_controller.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final controller = Get.put(OrderController());
  final state = Get.find<OrderController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SS.login.userType.isAgent ? "我的订单" : "我的订单"),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: controller.tabController,
          labelStyle: AppTextStyle.st.size(14.rpx),
          labelColor: AppColor.primary,
          unselectedLabelColor: AppColor.black92,
          tabs: List.generate(state.titleList.length,
              (index) => Tab(text: state.titleList[index])),
        ),
        actions: [],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: List.generate(
          state.titleList.length,
          (index) => OrderListPage(type: OrderListType.valueForIndex(index)),
        ),
      ),
    );
  }
}
