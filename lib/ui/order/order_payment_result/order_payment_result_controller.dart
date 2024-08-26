import 'package:get/get.dart';
import 'package:guanjia/common/network/api/order_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_payment_result_state.dart';

class OrderPaymentResultController extends GetxController {
  OrderPaymentResultController(this.orderId);

  final int orderId;

  final OrderPaymentResultState state = OrderPaymentResultState();

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  void toOrderDetail(int orderId) {
    Get.offNamed(AppRoutes.orderDetailPage, arguments: {"orderId": orderId});
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
      update();
    }

    return true;
  }
}
