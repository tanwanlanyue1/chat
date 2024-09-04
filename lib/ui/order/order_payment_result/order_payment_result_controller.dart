import 'package:get/get.dart';
import 'package:guanjia/common/network/api/order_api.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_payment_result_state.dart';

class OrderPaymentResultController extends GetxController {
  OrderPaymentResultController(
    this.orderId, {
    this.type = OrderPaymentType.dating,
  });

  final String orderId;

  final OrderPaymentType type;

  final OrderPaymentResultState state = OrderPaymentResultState();

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  void toOrderDetail(String orderId) {
    Get.offNamed(AppRoutes.orderDetailPage,
        arguments: {"orderId": int.tryParse(orderId) ?? 0});
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
        state.detailModel.value = model;
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
