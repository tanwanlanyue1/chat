import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/message_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/mine_message/widgets/mine_message_list_tile.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'wallet_order_list_controller.dart';
import 'wallet_order_list_state.dart';
import 'widget/wallet_order_list_tile.dart';

///充值提现订单列表
class WalletOrderListView extends StatefulWidget {
  ///1充值，2提现
  final int type;

  const WalletOrderListView({super.key, required this.type});

  @override
  State<WalletOrderListView> createState() => _WalletOrderListViewState();
}

class _WalletOrderListViewState extends State<WalletOrderListView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
      init: WalletOrderListController(type: widget.type),
      global: false,
      builder: (controller) {
        return SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: PagedListView.separated(
            padding: FEdgeInsets(vertical: 8.rpx),
            pagingController: controller.pagingController,
            builderDelegate: DefaultPagedChildBuilderDelegate<WalletOrderItem>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return WalletOrderListTile(
                  item: item,
                  type: widget.type,
                  onTap: () {
                    controller.onTapItem(item);
                  },
                );
              },
            ),
            separatorBuilder: (_, index) => Spacing.h8,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
