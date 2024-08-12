import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
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
    // onTapOrderAdd(31);
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

  Future<bool> onTapOrderAdd(int uid) async {
    Loading.show();
    final res = await OrderApi.add(uid: uid);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  Future<bool> onTapOrderCancel(int orderId) async {
    Loading.show();
    final res = await OrderApi.cancel(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  Future<bool> onTapOrderPayment(int orderId) async {
    // TODO: 弹出密码框
    Loading.show();
    final res = await OrderApi.pay(orderId: orderId, password: "123456");
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  void onTapOrderConnect() {}

  Future<bool> onTapOrderAcceptOrReject(bool isAccept, int orderId) async {
    Loading.show();
    final res =
        await OrderApi.acceptOrReject(type: isAccept ? 1 : 2, orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  Future<bool> onTapOrderAssign(int orderId) async {
    // TODO: 选择指派佳丽
    Loading.show();
    final res = await OrderApi.assign(orderId: orderId, receiveId: 1);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  Future<bool> onTapOrderFinish(int orderId) async {
    Loading.show();
    final res = await OrderApi.finish(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
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
      final items = res.data?.list ?? [];

      pagingController.appendPageData(
          items.map((e) => OrderListItem(itemModel: e)).toList());
    } else {
      pagingController.error = res.errorMessage;
    }
  }
}
