import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
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
    required this.itemType,
  }) : state = _getState(itemType);

  final OrderItemType itemType;

  final OrderListItemState state;

  String get stateText => state.text;

  Color get stateColor => state.color;

  OrderOperationType get operationType => state.operation;

  static OrderListItemState _getState(OrderItemType type) {
    final userType = SS.login.userType ?? UserType.user;
    print(userType);
    return stateMap[type]?[userType] ??
        OrderListItemState(
          text: "未知状态",
          color: Colors.grey,
        );
  }

  static final Map<OrderItemType, Map<UserType, OrderListItemState>> stateMap =
      {
    OrderItemType.waitingConfirm: {
      UserType.user: OrderListItemState(
        text: "等待对方接单",
        color: AppColor.textYellow,
        operation: OrderOperationType.cancel,
      ),
      UserType.beauty: OrderListItemState(
        text: "待您接单",
        color: AppColor.textBlue,
        operation: OrderOperationType.confirm,
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
    OrderItemType.waitingPaymentForUser: {
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
    OrderItemType.waitingPaymentForBeauty: {
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
    OrderItemType.going: {
      UserType.user: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.finish,
      ),
      UserType.beauty: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.finish,
      ),
      UserType.agent: OrderListItemState(
        text: "约会进行中",
        color: AppColor.textPurple,
        operation: OrderOperationType.connect,
      ),
    },
    OrderItemType.cancelForUser: {
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
    OrderItemType.cancelForBeauty: {
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
    OrderItemType.waitingEvaluation: {
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
  };
}
