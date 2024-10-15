import 'package:get/get.dart';

import 'recharge_order_state.dart';

class RechargeOrderController extends GetxController {
  final RechargeOrderState state = RechargeOrderState();

  ///完成转账
  void onTapComplete(){
    state.orderStatusRx.value = RechargeOrderStatus.success;
  }
}
