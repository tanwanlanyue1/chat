import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';

class OrderListItemWrapper {
  final String avatar; // 头像
  final String nick; // 昵称
  final String? nickWithAgent; // 经纪人下拓展昵称
  final String stateText; // 订单状态文本
  final Color stateTextColor; // 订单状态文本颜色
  final OrderOperationType operation; // 订单操作类型

  OrderListItemWrapper({
    required this.avatar,
    required this.nick,
    this.nickWithAgent,
    required this.stateText,
    required this.stateTextColor,
    this.operation = OrderOperationType.none,
  });
}

class OrderListItem {
  OrderListItem({
    required this.itemModel,
  }) {
    itemType = getType(itemModel);
    _wrapper = _getWrapper(itemModel, itemType);
  }

  // 原始数据
  final OrderItemModel itemModel;

  // 订单类型
  late final OrderItemState itemType;

  // 订单id
  int get id => itemModel.id;

  // 订单倒计时 不为空就显示
  String? get countDown => itemModel.countDown > 0
      ? "剩余等待 ${CommonUtils.convertCountdownToHMS(itemModel.countDown, hasHours: false)}"
      : null;

  // 订单界面包装器
  late final OrderListItemWrapper _wrapper;

  // 订单创建时间
  String get time => itemModel.createTime;

  // 订单编号
  String get number => "订单编号：${itemModel.number}";

  // 订单头像
  String get avatar => _wrapper.avatar;

  // 订单不同状态昵称
  String get nick => _wrapper.nick;

  // 订单接约人，订单类型为普通订单时，并且角色为经纪人的某些状态下会有值
  String? get nickWithAgent => _wrapper.nickWithAgent;

  // 订单状态文本
  String get stateText => _wrapper.stateText;

  // 订单状态文本颜色
  Color get stateTextColor => _wrapper.stateTextColor;

  // 订单操作类型
  OrderOperationType get operationType => _wrapper.operation;

  /// 根据订单模型组装新的订单类型
  static OrderItemState getType(OrderItemModel model) {
    final orderType = model.type;
    final orderState = model.state;
    final requestState = model.requestState;
    final receiveState = model.receiveState;

    if (orderType.isNormal) {
      final userId = SS.login.userId;
      final userType = userId == model.requestId
          ? UserType.user
          : userId == model.receiveId
              ? UserType.beauty
              : UserType.agent;

      switch (orderState) {
        case OrderState.waitingAcceptance:
          if (userType.isAgent) {
            // 当前用户是经纪人，接收方为空时，改为指派状态
            return model.receiveId == 0
                ? OrderItemState.waitingAssign
                : OrderItemState.waitingAcceptance;
          }
          return OrderItemState.waitingAcceptance;

        case OrderState.waitingPayment:
          // 根据用户类型和订单状态确定订单项类型
          return userType.isBeauty
              ? (receiveState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForReceive
                  : OrderItemState.waitingPaymentForRequest)
              : (requestState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForRequest
                  : OrderItemState.waitingPaymentForReceive);

        case OrderState.going:
          return receiveState.isConfirm
              ? OrderItemState.waitingConfirmForRequest
              : OrderItemState.waitingConfirmForReceive;

        case OrderState.cancel:
          // 优先显示请求方取消状态
          return requestState.isCancel
              ? OrderItemState.cancelForRequest
              : OrderItemState.cancelForReceive;

        case OrderState.finish:
          // 评价星值为0时，改为等待评价状态
          return model.evaluateScore == 0
              ? OrderItemState.waitingEvaluation
              : OrderItemState.finish;
      }
    } else {
      final itemUserType = model.requestId == SS.login.userId
          ? OrderItemUserType.request
          : OrderItemUserType.receive;

      switch (orderState) {
        case OrderState.waitingAcceptance:
          // 征友订单不存在等待接受的状态
          return OrderItemState.unknown;

        case OrderState.waitingPayment:
          // 根据用户类型和订单状态确定订单项类型
          return itemUserType.isReceive
              ? (receiveState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForReceive
                  : OrderItemState.waitingPaymentForRequest)
              : (requestState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForRequest
                  : OrderItemState.waitingPaymentForReceive);

        case OrderState.going:
          // 接受方需要先确认订单后再进行请求方确认
          return receiveState.isConfirm
              ? OrderItemState.waitingConfirmForRequest
              : OrderItemState.waitingConfirmForReceive;

        case OrderState.cancel:
          // 优先显示请求方取消状态
          return requestState.isCancel
              ? OrderItemState.cancelForRequest
              : OrderItemState.cancelForReceive;

        case OrderState.finish:
          return OrderItemState.finish;
      }
    }
  }

  /// 根据订单类型和状态进行组装
  static OrderListItemWrapper _getWrapper(
    OrderItemModel model,
    OrderItemState state,
  ) {
    final OrderListItemWrapper? wrapper;

    if (model.type.isNormal) {
      final userId = SS.login.userId;
      final userType = userId == model.requestId
          ? UserType.user
          : userId == model.receiveId
              ? UserType.beauty
              : UserType.agent;
      wrapper = buildNormalWrapperMap(model)[state]?[userType];
    } else {
      final userType = model.requestId == SS.login.userId
          ? OrderItemUserType.request
          : OrderItemUserType.receive;
      wrapper = buildFriendWrapperMap(model)[state]?[userType];
    }

    return wrapper ??
        OrderListItemWrapper(
          avatar: "",
          nick: "",
          stateText: "未知状态",
          stateTextColor: Colors.grey,
        );
  }

  static Map<OrderItemState, Map<UserType, OrderListItemWrapper>>
      buildNormalWrapperMap(OrderItemModel model) {
    return {
      OrderItemState.waitingAcceptance: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveId == 0
              ? model.introducerAvatar
              : model.receiveAvatar,
          nick: model.receiveId == 0
              ? "接约人：${model.introducerName}"
              : "接约人：${model.receiveName}",
          stateText: "等待对方接单",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "待您接单",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.accept,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "等待佳丽接单",
          stateTextColor: AppColor.textRed,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "待您指派接单",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.assign,
        ),
      },
      OrderItemState.waitingPaymentForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "待您缴费",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.payment,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "等待用户缴费",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "等待用户缴费",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.none,
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "等待佳丽缴纳保证金",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "待您缴纳保证金",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.payment,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "等待佳丽缴纳保证金",
          stateTextColor: AppColor.textRed,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.none,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancelAndFinish,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.cancelForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "您主动取消订单",
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "对方已取消订单",
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "用户已取消订单",
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.cancelForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveId == 0
              ? model.introducerAvatar
              : model.receiveAvatar,
          nick:
              "接约人：${model.receiveId == 0 ? model.introducerName : model.receiveName}",
          stateText: "对方已取消订单",
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "您主动取消订单",
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent:
              model.receiveId == 0 ? null : "接约人：${model.receiveName}",
          stateText: "佳丽已取消订单",
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.timeOut: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "等待超时",
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "等待超时",
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "等待超时",
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.finish: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "订单已完成",
          stateTextColor: AppColor.textGreen,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "订单已完成",
          stateTextColor: AppColor.textGreen,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "订单已完成",
          stateTextColor: AppColor.textGreen,
        ),
      },
      OrderItemState.waitingEvaluation: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "接约人：${model.receiveName}",
          stateText: "已确认完成，待评价",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.evaluation,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          stateText: "已确认完成，待用户评价",
          stateTextColor: AppColor.textGreen,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "下单用户：${model.requestName}",
          nickWithAgent: "接约人：${model.receiveName}",
          stateText: "已确认完成，待用户评价",
          stateTextColor: AppColor.textGreen,
        ),
      },
    };
  }

  static Map<OrderItemState, Map<OrderItemUserType, OrderListItemWrapper>>
      buildFriendWrapperMap(OrderItemModel model) {
    return {
      OrderItemState.waitingPaymentForRequest: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "待您缴费",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.payment,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "等待用户缴费",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "等待用户缴费",
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "待您缴费",
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.payment,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.finish,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.none,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancel,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "约会进行中",
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancelAndFinish,
        ),
      },
      OrderItemState.cancelForRequest: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "您主动取消订单",
          stateTextColor: AppColor.black9,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "对方已取消订单",
          stateTextColor: AppColor.black9,
        ),
      },
      OrderItemState.cancelForReceive: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "对方已取消订单",
          stateTextColor: AppColor.black9,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "您主动取消订单",
          stateTextColor: AppColor.black9,
        ),
      },
      OrderItemState.timeOut: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "等待超时",
          stateTextColor: AppColor.black9,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "等待超时",
          stateTextColor: AppColor.black9,
        ),
      },
      OrderItemState.finish: {
        OrderItemUserType.request: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "参与约会：${model.receiveName}",
          stateText: "订单已完成",
          stateTextColor: AppColor.textGreen,
        ),
        OrderItemUserType.receive: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "征友约会：${model.requestName}",
          stateText: "订单已完成",
          stateTextColor: AppColor.textGreen,
        ),
      },
    };
  }
}
