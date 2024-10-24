import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/order_list/order_list_page.dart';
import 'package:guanjia/ui/order/widgets/order_drop_menu_widget.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/tab_underline_indicator.dart';
import 'enum/order_enum.dart';
import 'order_controller.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(OrderController());
  final state = Get.find<OrderController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return wrapGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            SS.login.userType.isAgent ? S.current.teamOrder : S.current.myOrder,
          ),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            controller: controller.tabController,
            labelStyle: AppTextStyle.fs14b,
            labelColor: AppColor.primaryBlue,
            unselectedLabelColor: AppColor.grayText,
            indicatorPadding: FEdgeInsets(bottom: 8.rpx),
            indicator: TabUnderlineIndicator(
              width: 32.rpx,
              widthEqualTitle: false,
              strokeCap: StrokeCap.square,
              borderSide: BorderSide(
                width: 2.rpx,
                color: AppColor.primaryBlue,
              ),
            ),
            tabs: List.generate(
              state.titleList.length,
              (index) => Tab(
                text: state.titleList[index],
                height: 48.rpx,
              ),
            ),
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
                          size: 12.rpx,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  ///渐变背景
  Widget wrapGradientBackground({required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: AppColor.scaffoldBackground,
          alignment: Alignment.topCenter,
          child: Container(
            height: kNavigationBarHeight + Get.padding.top + 50.rpx,
            decoration: const BoxDecoration(
              gradient: AppColor.verticalGradientBaby,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
