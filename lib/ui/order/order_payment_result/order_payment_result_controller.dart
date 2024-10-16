import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
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
    this.vipPackage,
  });

  final int orderId;

  final OrderPaymentType type;
  final VipPackageModel? vipPackage;

  final OrderPaymentResultState state = OrderPaymentResultState();

  @override
  void onInit() {
    if(type == OrderPaymentType.dating){
      _fetchData();
    }
    super.onInit();
  }

  void toOrderDetail(int orderId) {
    Get.offNamed(AppRoutes.orderDetailPage,
        arguments: {"orderId": orderId});
  }

  Future<void> _fetchData() async {
    Loading.show();
    final res = await OrderApi.get(
      orderId: orderId,
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
  }
}
