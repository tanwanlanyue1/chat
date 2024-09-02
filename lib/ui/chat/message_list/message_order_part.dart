import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/widgets/order_accept_dialog.dart';
import 'package:guanjia/ui/order/widgets/order_create_dialog.dart';
import 'package:guanjia/ui/order/widgets/order_payment_dialog.dart';

import '../../../common/network/api/api.dart';
import 'message_list_controller.dart';

///消息列表-顶部订单功能
extension MessageOrderPart on MessageListController {

  ///获取订单信息
  Future<OrderItemModel?> fetchOrder() async {
    final response = await OrderApi.getLastByUid(otherUid: userId);
    if (response.isSuccess) {
      state.orderRx.value = response.data;
    }
    return state.orderRx();
  }

  ///点击订单操作
  void onTapOrderAction(
      OrderOperationType operation, OrderItemModel? order) async {
    switch (operation) {
      case OrderOperationType.create:
        _createOrder();
        break;
      case OrderOperationType.accept:
        order?.let(_acceptOrder);
        break;
      case OrderOperationType.assign:
        order?.let(_assignOrder);
        break;
      case OrderOperationType.payment:
        order?.let(_paymentOrder);
        break;
      case OrderOperationType.confirm:
        order?.let(_confirmOrder);
        break;
      case OrderOperationType.finish:
        order?.let(_finishOrder);
        break;
      default:
        break;
    }
  }

  ///发起约会订单
  void _createOrder() async {
    final isOk = await OrderCreateDialog.show(userId: userId);
    if (!isOk) {
      return;
    }
    await onTapOrderAdd(userId);
  }

  ///佳丽接单
  void _acceptOrder(OrderItemModel order) async {
    final isAccept = await OrderAcceptDialog.show(userId: userId);
    if (isAccept == null) {
      return;
    }
    await onTapOrderAcceptOrReject(isAccept, order.id);
  }

  ///经纪人指派订单给佳丽
  void _assignOrder(OrderItemModel order) async{
    await onTapOrderAssign(order.id);
  }

  ///缴纳保证金
  void _paymentOrder(OrderItemModel order) async {
    toOrderPayment(order);
  }

  ///佳丽确认已到位
  void _confirmOrder(OrderItemModel order) async {
    await onTapOrderFinish(order.id);
  }

  ///用户完成订单
  void _finishOrder(OrderItemModel order) {
    _confirmOrder(order);
  }
}
