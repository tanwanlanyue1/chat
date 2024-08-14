import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/order_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_state.dart';

class OrderListController extends GetxController with OrderOperationMixin {
  final OrderListType type;
  OrderListController(this.type);

  // 上级界面状态
  final orderState = Get.find<OrderController>().state;

  final OrderListState state = OrderListState();

  //分页控制器
  final pagingController = DefaultPagingController<OrderListItem>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    // onTapOrderAdd(30);
    orderState.selectDay.listen(_changeSelectDay);
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  @override
  Future<bool> onTapOrderCancel(int orderId) async {
    final res = await super.onTapOrderCancel(orderId);
    if (res) {
      _refreshTypeList(OrderListType.going);
      _refreshTypeList(OrderListType.cancel);
    }
    return res;
  }

  @override
  Future<bool> onTapOrderPayment(int orderId) async {
    final res = await super.onTapOrderPayment(orderId);
    if (res) _refreshTypeList(OrderListType.going);
    return res;
  }

  @override
  Future<bool> onTapOrderAcceptOrReject(bool isAccept, int orderId) async {
    final res = await super.onTapOrderAcceptOrReject(isAccept, orderId);
    if (res) {
      _refreshTypeList(OrderListType.going);
      if (isAccept) _refreshTypeList(OrderListType.cancel);
    }
    return res;
  }

  @override
  Future<bool> onTapOrderAssign(int orderId) async {
    final res = await super.onTapOrderAssign(orderId);
    if (res) _refreshTypeList(OrderListType.going);
    return res;
  }

  @override
  Future<bool> onTapOrderFinish(int orderId) async {
    final res = await super.onTapOrderFinish(orderId);
    if (res) {
      _refreshTypeList(OrderListType.going);
      _refreshTypeList(OrderListType.finish);
    }
    return res;
  }

  void _fetchPage(int page) async {
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

  // 刷新不同类型的订单列表
  void _refreshTypeList(OrderListType type) {
    if (Get.isRegistered<OrderListController>(tag: type.name)) {
      final c = Get.find<OrderListController>(tag: type.name);
      c.pagingController.refresh();
    }
  }

  // 切换日期 刷新列表
  void _changeSelectDay(int page) {
    if (type.index == orderState.selectIndex.value) {
      _refreshTypeList(type);
    }
  }
}
