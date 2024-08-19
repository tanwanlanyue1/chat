import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/order/model/order_detail.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_detail_state.dart';

class OrderDetailController extends GetxController with OrderOperationMixin {
  OrderDetailController(this.orderId);

  final int orderId;

  final OrderDetailState state = OrderDetailState();

  @override
  void onInit() async {
    _fetchData();
    super.onInit();
  }

  Future<bool> _fetchData() async {
    Loading.show();
    final res = await OrderApi.get(
      orderId: orderId,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }

    final model = res.data;
    if (model != null) {
      state.detailModel.value = OrderDetail(itemModel: model);
    }
    return true;
  }

  @override
  Future<bool> onTapOrderCancel(int orderId) async {
    final res = await super.onTapOrderCancel(orderId);
    if (res) return await _fetchData();
    return res;
  }

  @override
  Future<bool> onTapOrderPayment(int orderId) async {
    final res = await super.onTapOrderPayment(orderId);
    if (res) return await _fetchData();
    return res;
  }

  @override
  Future<bool> onTapOrderAcceptOrReject(bool isAccept, int orderId) async {
    final res = await super.onTapOrderAcceptOrReject(isAccept, orderId);
    if (res) return await _fetchData();
    return res;
  }

  @override
  Future<bool> onTapOrderAssign(int orderId) async {
    final res = await super.onTapOrderAssign(orderId);
    if (res) return await _fetchData();
    return res;
  }

  @override
  Future<bool> onTapOrderFinish(int orderId) async {
    final res = await super.onTapOrderFinish(orderId);
    if (res) return await _fetchData();
    return res;
  }
}
