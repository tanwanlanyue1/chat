import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/order_detail/widget/order_cancel_dialog.dart';
import 'package:guanjia/ui/order/order_list/order_list_controller.dart';
import 'package:guanjia/ui/order/widgets/assign_agent_dialog/order_assign_agent_dialog.dart';
import 'package:guanjia/ui/order/widgets/order_payment_dialog.dart';
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
  /// receiveId: 接单人id
  /// requestId: 发起人id
  Future<bool> onTapOrderCancel(int orderId,int receiveId,int requestId) async {
    int id = SS.login.info?.uid == receiveId ? requestId : receiveId;
    final cancel = await OrderCancelDialog.show(id);
    if(cancel == true){
      Loading.show();
      final res = await OrderApi.cancel(orderId: orderId);
      Loading.dismiss();
      if (!res.isSuccess) {
        res.showErrorMessage();
      return false;
      }
      return true;
    }
    return false;
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
      Get.offNamed(
        AppRoutes.orderPaymentResultPage,
        arguments: {"orderId": orderId, "isSuccess": false},
      );
      return false;
    }

    Get.offNamed(
      AppRoutes.orderPaymentResultPage,
      arguments: {"orderId": orderId, "isSuccess": true},
    );

    return true;
  }

  /// 佳丽接单
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
    if (res == null) return false;
    return res;
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
  void toOrderConnect(int uid) {
    ChatManager().startChat(userId: uid);
  }

  /// 跳转订单详情
  /// orderId: 订单id
  void toOrderDetail(int orderId) {
    Get.toNamed(AppRoutes.orderDetailPage, arguments: {"orderId": orderId});
  }

  /// 跳转评价订单
  /// orderId: 订单id
  void toOrderEvaluation(int orderId) {
    Get.toNamed(AppRoutes.orderEvaluationPage, arguments: orderId);
  }

  /// 跳转支付界面
  /// orderId: 订单id
  void toOrderPayment(OrderItemModel order) async {
    final ret = await OrderPaymentDialog.show(order: order);
    if (ret == true) {
      Get.toNamed(AppRoutes.orderPaymentPage, arguments: {"orderId": order.id});
    }
  }

  /// 刷新不同类型的订单列表
  /// type: 订单状态 going: 进行中; finish: 已完成; cancel: 已取消;
  void refreshTypeList(OrderListType type) {
    if (Get.isRegistered<OrderListController>(tag: type.name)) {
      final c = Get.find<OrderListController>(tag: type.name);
      c.pagingController.refresh();
    }
  }
}
