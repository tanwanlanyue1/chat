import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_detail_state.dart';

class OrderDetailController extends GetxController with OrderOperationMixin {
  OrderDetailController(this.orderId);

  final int orderId;

  final OrderDetailState state = OrderDetailState();

  @override
  void onInit() async {
    Loading.show();
    final res = await OrderApi.get(
      orderId: orderId,
    );
    Loading.dismiss();

    if (!res.isSuccess) res.showErrorMessage();

    super.onInit();
  }

  void onTapConfirm() {
    Get.toNamed(AppRoutes.orderEvaluationPage);
  }
}
