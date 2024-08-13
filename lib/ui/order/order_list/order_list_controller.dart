import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/widgets/assign_agent_dialog/order_assign_agent_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_state.dart';

class OrderListController extends GetxController {
  final OrderListType type;
  OrderListController(this.type);

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
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  void onTapToOrderDetail(int orderId) {
    Get.toNamed(AppRoutes.orderDetailPage);
  }

  Future<void> onTapOrderAdd(int uid) async {
    Loading.show();
    final res = await OrderApi.add(uid: uid);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    _refreshTypeList(OrderListType.going);
  }

  Future<void> onTapOrderCancel(int orderId) async {
    Loading.show();
    final res = await OrderApi.cancel(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    _refreshTypeList(OrderListType.going);
    _refreshTypeList(OrderListType.cancel);
  }

  Future<void> onTapOrderPayment(int orderId) async {
    // TODO: 弹出密码框
    Loading.show();
    final res = await OrderApi.pay(orderId: orderId, password: "123456");
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    _refreshTypeList(OrderListType.going);
  }

  void onTapOrderConnect(int uid) {
    MessageListPage.go(userId: uid);
  }

  Future<void> onTapOrderAcceptOrReject(bool isAccept, int orderId) async {
    Loading.show();
    final res =
        await OrderApi.acceptOrReject(type: isAccept ? 1 : 2, orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    _refreshTypeList(OrderListType.going);
    if (isAccept) _refreshTypeList(OrderListType.cancel);
  }

  Future<void> onTapOrderAssign(int orderId) async {
    final res = await OrderAssignAgentDialog.show(orderId);
    if (res == true) _refreshTypeList(OrderListType.going);
  }

  Future<void> onTapOrderFinish(int orderId) async {
    Loading.show();
    final res = await OrderApi.finish(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    _refreshTypeList(OrderListType.going);
    _refreshTypeList(OrderListType.finish);
  }

  void onTapOrderEvaluation(int orderId) {
    Get.toNamed(AppRoutes.orderEvaluationPage, arguments: orderId);
  }

  void _fetchPage(int page) async {
    final res = await OrderApi.getList(
      state: type.stateValue,
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
}
