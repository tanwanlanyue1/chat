import 'dart:async';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/order_api.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_payment_state.dart';

class OrderPaymentController extends GetxController with OrderOperationMixin {
  OrderPaymentController(this.orderId);

  final int orderId;

  final OrderPaymentState state = OrderPaymentState();

  Timer? _timer;

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
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

      state.countDown.value = model.countDown;
      if (model.countDown > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (state.countDown <= 0) {
            _timer?.cancel();
            return;
          }

          state.countDown.value = state.countDown.value - 1;
        });
      }

      update();
    }
    return true;
  }
}
