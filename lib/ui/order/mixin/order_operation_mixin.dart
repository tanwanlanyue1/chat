import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/order/widgets/assign_agent_dialog/order_assign_agent_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

/// 订单操作Mixin
mixin OrderOperationMixin {
  /// 新增订单
  /// uid: 用户id
  Future<bool> onTapOrderAdd(int uid) async {
    Loading.show();
    final res = await OrderApi.add(uid: uid);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  /// 取消订单
  /// orderId: 订单id
  Future<bool> onTapOrderCancel(int orderId) async {
    Loading.show();
    final res = await OrderApi.cancel(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  /// 支付订单
  /// orderId: 订单id
  Future<bool> onTapOrderPayment(int orderId) async {
    final password = await PaymentPasswordKeyboard.show();
    if (password == null) return false;

    Loading.show();
    final res = await OrderApi.pay(orderId: orderId, password: password);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  /// 支付订单
  /// isAccept: 是否接受
  /// orderId: 订单id
  Future<bool> onTapOrderAcceptOrReject(bool isAccept, int orderId) async {
    Loading.show();
    final res =
        await OrderApi.acceptOrReject(type: isAccept ? 1 : 2, orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  /// 指派佳丽
  /// orderId: 订单id
  Future<bool> onTapOrderAssign(int orderId) async {
    final res = await OrderAssignAgentDialog.show(orderId);
    return res ?? false;
  }

  /// 完成订单
  /// orderId: 订单id
  Future<bool> onTapOrderFinish(int orderId) async {
    Loading.show();
    final res = await OrderApi.finish(orderId: orderId);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return false;
    }
    return true;
  }

  /// 联系佳丽
  /// uid: 用户id
  void onTapToOrderConnect(int uid) {
    MessageListPage.go(userId: uid);
  }

  /// 跳转订单详情
  /// orderId: 订单id
  void onTapToOrderDetail(int orderId) {
    Get.toNamed(AppRoutes.orderDetailPage, arguments: {"orderId": orderId});
  }

  /// 跳转评价订单
  /// orderId: 订单id
  void onTapToOrderEvaluation(int orderId) {
    Get.toNamed(AppRoutes.orderEvaluationPage, arguments: orderId);
  }
}
