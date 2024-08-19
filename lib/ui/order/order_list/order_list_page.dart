import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/model/order_team_list_item.dart';
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
          _buildTop(),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.rpx),
            sliver: PagedSliverList.separated(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  if (item is OrderListItem) {
                    return _buildItem(item, index);
                  } else if (item is OrderTeamListItem) {
                    return _buildTeamItem(item, index);
                  }
                  return const SizedBox();
                },
              ),
              separatorBuilder: (_, int index) {
                if (controller.isTeamList) {
                  return SizedBox(height: 1.rpx);
                }
                return SizedBox(height: 8.rpx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop() {
    final userType = SS.login.userType;

    Widget? content;

    if (widget.type == OrderListType.cancel && !userType.isUser) {
      content = Obx(() {
        return Row(
          children: [
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.waitTimeCount.value,
                title: "等待超时",
              ),
            ),
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.otherCancelCount.value,
                title: "对方取消",
              ),
            ),
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.selfCancelCount.value,
                title: "主动取消",
              ),
            ),
          ],
        );
      });
    } else if (widget.type == OrderListType.finish && userType.isBeauty) {
      content = Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 2,
              child: OrderOperationNumberWidget(
                number: state.evaluateCount.value,
                title: "待评价",
                numberColor: AppColor.textGreen,
              ),
            ),
            Expanded(
              flex: 2,
              child: OrderOperationNumberWidget(
                number: state.completeCount.value,
                title: "已完成",
                numberColor: AppColor.textGreen,
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        );
      });
    }

    if (content == null) return const SliverToBoxAdapter();

    return SliverAppBar(
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
          child: content,
        ),
      ),
    );
  }

  Widget _buildTeamItem(OrderTeamListItem item, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            item.isSelect = !item.isSelect;
            setState(() {});
          },
          child: Container(
            height: 100.rpx,
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 60.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImage.network(
                        item.avatar,
                        length: 60.rpx,
                        shape: BoxShape.circle,
                      ),
                      SizedBox(height: 4.rpx),
                      Text(
                        item.nickname,
                        style: AppTextStyle.st
                            .size(12.rpx)
                            .textColor(AppColor.black3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${item.amountCount}",
                            style: AppTextStyle.st.bold
                                .size(18.rpx)
                                .textColor(AppColor.textGreen),
                          ),
                          TextSpan(
                            text: " 单",
                            style: AppTextStyle.st
                                .size(12.rpx)
                                .textColor(AppColor.black6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80.rpx,
                  height: 64.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldBackground,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${item.waitingEvaluateCount}",
                        style: AppTextStyle.st.bold
                            .size(18.rpx)
                            .textColor(AppColor.textGreen),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.rpx),
                      Text(
                        "待评价",
                        style: AppTextStyle.st
                            .size(12.rpx)
                            .textColor(AppColor.black3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.rpx),
                Container(
                  width: 80.rpx,
                  height: 64.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldBackground,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${item.finishCount}",
                        style: AppTextStyle.st.bold
                            .size(18.rpx)
                            .textColor(AppColor.textGreen),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.rpx),
                      Text(
                        "已完成",
                        style: AppTextStyle.st
                            .size(12.rpx)
                            .textColor(AppColor.black3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.rpx),
                AppImage.asset(
                  item.isSelect
                      ? "assets/images/common/arrow_up.png"
                      : "assets/images/common/arrow_down.png",
                  length: 20.rpx,
                ),
              ],
            ),
          ),
        ),
        if (item.isSelect)
          ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8.rpx),
              itemBuilder: (_, index) {
                final subItem = item.list[index];
                return _buildItem(subItem, index);
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemCount: item.list.length),
      ],
    );
  }

  Widget _buildItem(OrderListItem item, int index) {
    Widget operationWidget =
        OrderOperationButtons(type: widget.type, item: item);

    return GestureDetector(
      onTap: () => controller.onTapToOrderDetail(item.id),
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
                      item.time,
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.black9),
                    ),
                    SizedBox(width: 8.rpx),
                  ],
                ),
                if (item.countDown != null)
                  Flexible(
                    child: Text(
                      item.countDown!,
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
                AppImage.network(
                  item.avatar,
                  length: 60.rpx,
                  shape: BoxShape.circle,
                ),
                SizedBox(width: 8.rpx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.number,
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.nick,
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.nickWithAgent != null)
                        Text(
                          item.nickWithAgent ?? "",
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
                    style: AppTextStyle.st
                        .size(14.rpx)
                        .textColor(item.stateTextColor),
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
