import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/order_list/order_list_state.dart';
import 'package:guanjia/ui/order/widgets/order_operation_buttons.dart';
import 'package:guanjia/ui/order/widgets/order_operation_number_widget.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_controller.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key, required this.type});

  final OrderListType type;

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with AutomaticKeepAliveClientMixin {
  late final OrderListController controller;
  late final OrderListState state;

  @override
  void initState() {
    controller =
        Get.put(OrderListController(widget.type), tag: widget.type.name);
    state = Get.find<OrderListController>(tag: widget.type.name).state;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.pagingController.refreshController,
      onRefresh: controller.pagingController.onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 64.rpx,
            toolbarHeight: 64.rpx,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsets.zero,
              title: Container(
                margin: EdgeInsets.only(top: 1.rpx),
                // height: 64.rpx,
                color: Colors.white,
                child: Row(children: [
                  Expanded(
                    child: OrderOperationNumberWidget(
                      number: 1,
                      title: "等待超时",
                    ),
                  ),
                  Expanded(
                    child: OrderOperationNumberWidget(
                      number: 1,
                      title: "对方取消",
                    ),
                  ),
                  Expanded(
                    child: OrderOperationNumberWidget(
                      number: 1,
                      title: "主动取消",
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.rpx),
            sliver: PagedSliverList.separated(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<OrderListItem>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return _buildItem(item, index);
                },
              ),
              separatorBuilder: (_, int index) {
                return SizedBox(height: 8.rpx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(OrderListItem item, int index) {
    Widget operationWidget = OrderOperationButtons(
        type: widget.type, operationType: item.operationType);

    return GestureDetector(
      onTap: controller.onTapItem,
      child: Container(
        height: 186.rpx,
        padding: EdgeInsets.all(16.rpx).copyWith(bottom: 0),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppImage.asset(
                      "assets/images/order/time.png",
                      length: 16.rpx,
                    ),
                    SizedBox(width: 8.rpx),
                    Text(
                      "2021-12-20 16:33",
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.black9),
                    ),
                    SizedBox(width: 8.rpx),
                  ],
                ),
                Flexible(
                  child: Text(
                    "剩余等待 29:59",
                    style: AppTextStyle.st
                        .size(12.rpx)
                        .textColor(AppColor.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(
              height: 25.rpx,
              thickness: 1.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Row(
              children: [
                Container(
                  width: 60.rpx,
                  height: 60.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.rpx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "订单编号：883437307502375017",
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "接约人：Kiko",
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.rpx),
            Divider(
              height: 1.rpx,
              thickness: 1.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.stateText,
                    style:
                        AppTextStyle.st.size(14.rpx).textColor(item.stateColor),
                  ),
                  SizedBox(width: 8.rpx),
                  Flexible(
                    child: operationWidget,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
