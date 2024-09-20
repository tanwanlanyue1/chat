import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/order_list/order_list_page.dart';
import 'package:guanjia/ui/order/widgets/order_drop_menu_widget.dart';
import 'package:guanjia/widgets/app_image.dart';
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
        title: Text(SS.login.userType.isAgent ? S.current.teamOrder : S.current.myOrder),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: controller.tabController,
          labelStyle: AppTextStyle.fs14b,
          labelColor: AppColor.primaryBlue,
          unselectedLabelColor: AppColor.grayText,
          indicatorColor: AppColor.primaryBlue,
          indicatorWeight: 2.rpx,
          tabs: List.generate(state.titleList.length,
              (index) => Tab(text: state.titleList[index], height: 40.rpx)),
        ),
        actions: [
          Obx(() {
            if (state.isShowDay.value) {
              return GestureDetector(
                onTap: null,
                child: Container(
                  margin: EdgeInsets.only(right: 16.rpx),
                  alignment: Alignment.centerRight,
                  child: OrderDropMenuWidget(
                    maxWidth: 64.rpx,
                    data: state.days,
                    selectCallBack: (value) {
                      controller.onChooseDay(value);
                    },
                    trailing: Padding(
                      padding: EdgeInsets.only(left: 4.rpx),
                      child: AppImage.asset(
                        "assets/images/common/solid_arrow_down.png",
                        length: 12.rpx,
                      ),
                    ),
                    selectedValue: state.selectDay.value,
                    offset: const Offset(0, 31),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
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
