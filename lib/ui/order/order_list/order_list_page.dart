import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/model/order_team_list_item.dart';
import 'package:guanjia/ui/order/order_list/order_list_state.dart';
import 'package:guanjia/ui/order/widgets/order_operation_buttons.dart';
import 'package:guanjia/ui/order/widgets/order_operation_number_widget.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/user_avatar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_controller.dart';
import 'widget/order_list_tile.dart';

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
            padding: EdgeInsets.symmetric(vertical: 12.rpx, horizontal: 16.rpx),
            sliver: PagedSliverList.separated(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  if (item is OrderListItem) {
                    return OrderListTile(
                        onTap: () => controller.toOrderDetail(item.id),
                        widget: widget,
                        item: item,
                        index: index);
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
                title: S.current.waitTimeout,
                icon: 'assets/images/order/ic_order_timeout.png',
              ),
            ),
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.otherCancelCount.value,
                title: S.current.counterpartyCancel,
                icon: 'assets/images/order/ic_order_cancel_other.png',
              ),
            ),
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.selfCancelCount.value,
                title: S.current.activeCancellation,
                icon: 'assets/images/order/ic_order_cancel.png',
              ),
            ),
          ],
        );
      });
    } else if (widget.type == OrderListType.finish && userType.isBeauty) {
      content = Obx(() {
        return Row(
          children: [
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.evaluateCount.value,
                title: S.current.remainBeEvaluated,
                icon: 'assets/images/order/ic_order_wait_comment.png',
              ),
            ),
            Expanded(
              child: OrderOperationNumberWidget(
                number: state.completeCount.value,
                title: S.current.completed,
                icon: 'assets/images/order/ic_order_completed.png',
              ),
            ),
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
      backgroundColor: AppColor.scaffoldBackground,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.0,
        titlePadding: EdgeInsets.zero,
        title: Container(
          // height: 64.rpx,
          margin: const EdgeInsets.only(top: 1),
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
                      UserAvatar.circle(
                        item.avatar,
                        size: 60.rpx,
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
                            style: AppTextStyle.st.medium
                                .size(18.rpx)
                                .textColor(AppColor.textGreen),
                          ),
                          TextSpan(
                            text: " ${S.current.bill}",
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
                        style: AppTextStyle.st.medium
                            .size(18.rpx)
                            .textColor(AppColor.textGreen),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.rpx),
                      Text(
                        S.current.remainBeEvaluated,
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
                        style: AppTextStyle.st.medium
                            .size(18.rpx)
                            .textColor(AppColor.textGreen),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.rpx),
                      Text(
                        S.current.completed,
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
                  size: 20.rpx,
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
                return OrderListTile(
                    onTap: () => controller.toOrderDetail(subItem.id),
                    widget: widget,
                    item: subItem,
                    index: index);
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

  @override
  bool get wantKeepAlive => true;
}

