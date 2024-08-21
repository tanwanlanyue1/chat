import 'package:get/get.dart';
import 'package:guanjia/common/network/api/order_api.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/order/model/order_detail.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_payment_state.dart';

class OrderPaymentController extends GetxController with OrderOperationMixin {
  OrderPaymentController(this.orderId);

  final int orderId;

  final OrderPaymentState state = OrderPaymentState();

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  void onTapPaymentType(int index) {
    state.selectIndex.value = index;
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
      state.detailModel.value = model;
    }
    return true;
  }
}
