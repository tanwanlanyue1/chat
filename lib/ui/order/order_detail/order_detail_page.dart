import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'order_detail_controller.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key});

  final controller = Get.put(OrderDetailController());
  final state = Get.find<OrderDetailController>().state;

  @override
  Widget build(BuildContext context) {
    print(kToolbarHeight);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '订单详情',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppImage.asset(
              "assets/images/order/detail_top_bg.png",
              height: Get.padding.top + kNavigationBarHeight + 162.rpx,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
