import 'dart:async';

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/model/order_team_list_item.dart';
import 'package:guanjia/ui/order/order_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_state.dart';

class OrderListController extends GetxController with OrderOperationMixin {
  final OrderListType type;
  OrderListController(this.type);

  // 上级界面状态
  final orderState = Get.find<OrderController>().state;

  final OrderListState state = OrderListState();

  bool get isTeamList =>
      SS.login.userType.isAgent && type == OrderListType.finish;

  // 分页控制器
  late final DefaultPagingController pagingController;

  @override
  void onInit() {
    orderState.selectDay.listen(_changeSelectDay);

    pagingController = DefaultPagingController(
      firstPage: 1,
      pageSize: isTeamList ? 99999 : 10,
      refreshController: RefreshController(),
    );

    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  void _fetchPage(int page) async {
    if (isTeamList) {
      final res = await OrderApi.getTeamList(
        day: orderState.isShowDay.value ? orderState.selectDay.value : 0,
      );

      if (res.isSuccess) {
        final listSubModel = res.data?.list ?? [];
        pagingController.appendPageData(
            listSubModel.map((e) => OrderTeamListItem(itemModel: e)).toList());
      } else {
        pagingController.error = res.errorMessage;
      }

      return;
    }

    final res = await OrderApi.getList(
      state: type.stateValue,
      day: orderState.isShowDay.value ? orderState.selectDay.value : null,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      final listModel = res.data;

      if (listModel != null) {
        state.waitTimeCount.value = listModel.waitTimeCount;
        state.otherCancelCount.value = listModel.otherCancelCount;
        state.selfCancelCount.value = listModel.selfCancelCount;
        state.evaluateCount.value = listModel.evaluateCount;
        state.completeCount.value = listModel.completeCount;
        state.allCompleteCount.value = listModel.allCompleteCount;
      }

      final items = listModel?.list ?? [];

      pagingController.appendPageData(
          items.map((e) => OrderListItem(itemModel: e)).toList());
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  // 切换日期 刷新列表
  void _changeSelectDay(int page) {
    if (type.index == orderState.selectIndex.value) {
      refreshTypeList(type);
    }
  }
}
