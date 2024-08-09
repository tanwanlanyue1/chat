import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';

class OrderListState {}

class OrderListItemState {
  final String text;
  final Color color;
  final OrderOperationType operation;

  OrderListItemState({
    required this.text,
    required this.color,
    this.operation = OrderOperationType.none,
  });
}

class OrderListItem {
  OrderListItem({
    required this.itemModel,
  })  : id = itemModel.id,
        itemType = _getType(itemModel),
        state = _getState(_getType(itemModel));

  final OrderItemModel itemModel;

  // 订单类型
  final OrderItemType itemType;

  // 订单界面状态
  final OrderListItemState state;

  // 订单id
  final int id;

  // 订单状态文本
  String get stateText => state.text;

  // 订单状态文本颜色
  Color get stateTextColor => state.color;

  OrderOperationType get operationType => state.operation;

  /// 根据订单模型组装新的订单类型
  static OrderItemType _getType(OrderItemModel model) {
    final userType = SS.login.userType;
    final orderType = model.type;
    final orderState = model.state;
    final requestState = model.requestState;
    final receiveState = model.receiveState;

    switch (orderState) {
      case OrderState.waitingAcceptance:
        if (userType.isAgent) {
          // 当前用户是经纪人，接收方为空时，改为指派状态
          return model.receiveId == 0
              ? OrderItemType.waitingAssign
              : OrderItemType.waitingAcceptance;
        }
        return OrderItemType.waitingAcceptance;

      case OrderState.waitingPayment:
        // 根据用户类型和订单状态确定订单项类型
        return userType.isBeauty
            ? (receiveState.isWaitingPayment
                ? OrderItemType.waitingPaymentForReceive
                : OrderItemType.waitingPaymentForRequest)
            : (requestState.isWaitingPayment
                ? OrderItemType.waitingPaymentForRequest
                : OrderItemType.waitingPaymentForReceive);

      case OrderState.going:
        return receiveState.isConfirm
            ? OrderItemType.waitingConfirmForRequest
            : OrderItemType.waitingConfirmForReceive;

      case OrderState.cancel:
        // 优先显示请求方取消状态
        return requestState.isCancel
            ? OrderItemType.cancelForRequest
            : OrderItemType.cancelForReceive;

      case OrderState.finish:
        // 当订单类型是正常订单 并且 当前用户是普通用户，且评价星值为0时，改为等待评价状态
        print(orderType.isNormal);
        print(userType.isUser);
        print(model.evaluateScore);
        if (orderType.isNormal && model.evaluateScore == 0) {
          return OrderItemType.waitingEvaluation;
        }
        return OrderItemType.finish;
    }
  }

  /// 根据订单类型组装新的 订单界面状态
  static OrderListItemState _getState(OrderItemType type) {
    final userType = SS.login.userType;
    return stateMap[type]?[userType] ??
        OrderListItemState(
          text: "未知状态",
          color: Colors.grey,
        );
  }

  static final Map<OrderItemType, Map<UserType, OrderListItemState>> stateMap =
      {
    OrderItemType.waitingAcceptance: {
      UserType.user: OrderListItemState(
        text: "等待对方接单",
        color: AppColor.textYellow,
        operation: OrderOperationType.cancel,
      ),
      UserType.beauty: OrderListItemState(
        text: "待您接单",
        color: AppColor.textBlue,
        operation: OrderOperationType.accept,
      ),
      UserType.agent: OrderListItemState(
        text: "等待佳丽接单",
        color: AppColor.textRed,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.waitingAssign: {
      UserType.agent: OrderListItemState(
        text: "待您指派接单",
        color: AppColor.textBlue,
        operation: OrderOperationType.assign,
      ),
    },
    OrderItemType.waitingPaymentForRequest: {
      UserType.user: OrderListItemState(
        text: "待您缴费",
        color: AppColor.textBlue,
        operation: OrderOperationType.payment,
      ),
      UserType.beauty: OrderListItemState(
        text: "等待用户缴费",
        color: AppColor.textYellow,
        operation: OrderOperationType.cancel,
      ),
      UserType.agent: OrderListItemState(
        text: "等待用户缴费",
        color: AppColor.textYellow,
        operation: OrderOperationType.none,
      ),
    },
    OrderItemType.waitingPaymentForReceive: {
      UserType.user: OrderListItemState(
        text: "等待佳丽缴纳保证金",
        color: AppColor.textYellow,
        operation: OrderOperationType.cancel,
      ),
      UserType.beauty: OrderListItemState(
        text: "待您缴纳保证金",
        color: AppColor.textBlue,
        operation: OrderOperationType.payment,
      ),
      UserType.agent: OrderListItemState(
        text: "等待佳丽缴纳保证金",
        color: AppColor.textRed,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.waitingConfirmForRequest: {
      UserType.user: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.finish,
      ),
      UserType.beauty: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.none,
      ),
      UserType.agent: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.waitingConfirmForReceive: {
      UserType.user: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.cancel,
      ),
      UserType.beauty: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.cancelAndFinish,
      ),
      UserType.agent: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.cancelForRequest: {
      UserType.user: OrderListItemState(
        text: "您主动取消订单",
        color: AppColor.black9,
      ),
      UserType.beauty: OrderListItemState(
        text: "对方已取消订单",
        color: AppColor.black9,
      ),
      UserType.agent: OrderListItemState(
        text: "用户已取消订单",
        color: AppColor.black9,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.cancelForReceive: {
      UserType.user: OrderListItemState(
        text: "对方已取消订单",
        color: AppColor.black9,
      ),
      UserType.beauty: OrderListItemState(
        text: "您主动取消订单",
        color: AppColor.black9,
      ),
      UserType.agent: OrderListItemState(
        text: "佳丽已取消订单",
        color: AppColor.black9,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.timeOut: {
      UserType.user: OrderListItemState(
        text: "等待超时",
        color: AppColor.black9,
      ),
      UserType.beauty: OrderListItemState(
        text: "等待超时",
        color: AppColor.black9,
      ),
      UserType.agent: OrderListItemState(
        text: "等待超时",
        color: AppColor.black9,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.finish: {
      UserType.user: OrderListItemState(
        text: "订单已完成",
        color: AppColor.textGreen,
      ),
      UserType.beauty: OrderListItemState(
        text: "订单已完成",
        color: AppColor.textGreen,
      ),
      UserType.agent: OrderListItemState(
        text: "订单已完成",
        color: AppColor.textGreen,
      ),
    },
    OrderItemType.waitingEvaluation: {
      UserType.user: OrderListItemState(
        text: "已确认完成，待评价",
        color: AppColor.textBlue,
        operation: OrderOperationType.evaluation,
      ),
      UserType.beauty: OrderListItemState(
        text: "已确认完成，待用户评价",
        color: AppColor.textGreen,
      ),
      UserType.agent: OrderListItemState(
        text: "已确认完成，待用户评价",
        color: AppColor.textGreen,
      ),
    },
  };
}
