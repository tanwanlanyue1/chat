import 'dart:async';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/order_api.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_payment_state.dart';

class OrderPaymentController extends GetxController with OrderOperationMixin {
  OrderPaymentController(
    this.orderId, {
    this.type = OrderPaymentType.dating,
  });

  final String orderId;

  final OrderPaymentType type;

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

  Future<void> _fetchData() async {
    if (type == OrderPaymentType.dating) {
      Loading.show();
      final res = await OrderApi.get(
        orderId: int.tryParse(orderId) ?? 0,
      );
      Loading.dismiss();

      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      final model = res.data;
      if (model != null) {
        state.datingModel.value = model;

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
    } else {
      Loading.show();
      final res = await PaymentApi.getOrderInfo(
        orderNo: orderId,
      );
      Loading.dismiss();

      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      final model = res.data;
      if (model != null) {
        state.vipModel.value = model;
        update();
      }
    }
  }
}
