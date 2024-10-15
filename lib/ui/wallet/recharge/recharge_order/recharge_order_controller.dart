import 'package:get/get.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'recharge_order_state.dart';

class RechargeOrderController extends GetxController {
  final RechargeOrderState state = RechargeOrderState();

  ///订单流水号
  final String orderNo;

  RechargeOrderController({required this.orderNo});

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async{
    Loading.show();
    final response = await PaymentApi.getOrderInfo(orderNo);
    Loading.dismiss();
    if(response.isSuccess){

    }else{
      response.showErrorMessage();
    }
  }

  ///超时
  void onExpired(){
    state.orderRx.update((val) {
      val?.orderStatus = 2;
    });
  }

  ///完成转账
  void onTapComplete(){
    // state.orderStatusRx.value = RechargeOrderStatus.success;
  }
}
