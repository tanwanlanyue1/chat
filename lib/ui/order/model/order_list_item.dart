import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';

class OrderListItemWrapper {
  final String avatar; // 头像
  final String nick; // 昵称
  final String? nickWithAgent; // 经纪人下拓展昵称
  final String stateText; // 订单状态文本
  final Color stateTextColor; // 订单状态文本颜色
  final List<Color>? stateTextGradient; // 订单状态文本背景渐变
  final OrderOperationType operation; // 订单操作类型

  OrderListItemWrapper({
    required this.avatar,
    required this.nick,
    this.nickWithAgent,
    required this.stateText,
    required this.stateTextColor,
    this.stateTextGradient,
    this.operation = OrderOperationType.none,
  });
}

class OrderListItem {
  OrderListItem({
    required this.itemModel,
  }) {
    itemType = getType(itemModel);
    _wrapper = _getWrapper(itemModel, itemType);
    countDown = itemModel.countDown;
  }

  // 原始数据
  final OrderItemModel itemModel;

  // 订单类型
  late final OrderItemState itemType;

  // 订单id
  int get id => itemModel.id;

  // 订单倒计时 大于0就显示
  late int countDown;

  // 订单界面包装器
  late final OrderListItemWrapper _wrapper;

  // 订单创建时间
  String get time => CommonUtils.convertTimestampToString(itemModel.createTime,
      newPattern: DateFormats.y_mo_d_h_m);

  // 订单编号
  String get number => "${S.current.orderReference}${itemModel.number}";

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
        case OrderStatus.waitingAcceptance:
          if (userType.isAgent) {
            // 当前用户是经纪人，接收方为空时，改为指派状态
            return model.receiveId == 0
                ? OrderItemState.waitingAssign
                : OrderItemState.waitingAcceptance;
          }
          return OrderItemState.waitingAcceptance;

        case OrderStatus.waitingPayment:
          // 根据用户类型和订单状态确定订单项类型
          return userType.isBeauty
              ? (receiveState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForReceive
                  : OrderItemState.waitingPaymentForRequest)
              : (requestState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForRequest
                  : OrderItemState.waitingPaymentForReceive);

        case OrderStatus.going:
          return receiveState.isConfirm
              ? OrderItemState.waitingConfirmForRequest
              : OrderItemState.waitingConfirmForReceive;

        case OrderStatus.cancel:
          // 优先显示请求方取消状态
          return requestState.isCancel
              ? OrderItemState.cancelForRequest
              : OrderItemState.cancelForReceive;

        case OrderStatus.timeOut:
          return OrderItemState.timeOut;

        case OrderStatus.finish:
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
        case OrderStatus.waitingAcceptance:
          // 征友订单不存在等待接受的状态
          return OrderItemState.unknown;

        case OrderStatus.waitingPayment:
          // 根据用户类型和订单状态确定订单项类型
          return itemUserType.isReceive
              ? (receiveState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForReceive
                  : OrderItemState.waitingPaymentForRequest)
              : (requestState.isWaitingPayment
                  ? OrderItemState.waitingPaymentForRequest
                  : OrderItemState.waitingPaymentForReceive);

        case OrderStatus.going:
          // 接受方需要先确认订单后再进行请求方确认
          return receiveState.isConfirm
              ? OrderItemState.waitingConfirmForRequest
              : OrderItemState.waitingConfirmForReceive;

        case OrderStatus.cancel:
          // 优先显示请求方取消状态
          return requestState.isCancel
              ? OrderItemState.cancelForRequest
              : OrderItemState.cancelForReceive;

        case OrderStatus.timeOut:
          return OrderItemState.timeOut;

        case OrderStatus.finish:
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

    // TODO: 目前需求全部使用普通订单用户类型去封装，目前只有少数字段显示不同，后续有需要再细分
    final userId = SS.login.userId;
    final userType = userId == model.requestId
        ? UserType.user
        : userId == model.receiveId
            ? UserType.beauty
            : UserType.agent;
    wrapper = buildNormalWrapperMap(model)[state]?[userType];

    // if (model.type.isNormal) {
    //   final userId = SS.login.userId;
    //   final userType = userId == model.requestId
    //       ? UserType.user
    //       : userId == model.receiveId
    //           ? UserType.beauty
    //           : UserType.agent;
    //   wrapper = buildNormalWrapperMap(model)[state]?[userType];
    // } else {
    //   final userType = model.requestId == SS.login.userId
    //       ? OrderItemUserType.request
    //       : OrderItemUserType.receive;
    //   wrapper = buildFriendWrapperMap(model)[state]?[userType];
    // }

    return wrapper ??
        OrderListItemWrapper(
          avatar: "",
          nick: "",
          stateText: S.current.unknownState,
          stateTextColor: Colors.grey,
        );
  }

  static Map<OrderItemState, Map<UserType, OrderListItemWrapper>>
      buildNormalWrapperMap(OrderItemModel model) {
    final isNormal = model.type.isNormal;

    final requestNamePrefix = isNormal ? S.current.orderUser : "${S.current.dating}：";
    final receiveNamePrefix = isNormal ? S.current.appointee : S.current.goOnADate;
    final receiveName =
        model.receiveId == 0 ? model.introducerName : model.receiveName;
    final receiveAvatar =
        model.receiveId == 0 ? model.introducerAvatar : model.receiveAvatar;
    return {
      OrderItemState.waitingAcceptance: {
        UserType.user: OrderListItemWrapper(
          avatar: receiveAvatar,
          nick: "$receiveNamePrefix$receiveName",
          stateText: S.current.waitOtherOrder,
          stateTextColor: AppColor.babyBlueButton,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.waitingForYourOrder,
          stateTextColor: AppColor.babyBlueButton,
          operation: OrderOperationType.accept,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.waitBelleOrder,
          stateTextColor: AppColor.textRed,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.waitingYourAssignmentOrders,
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.assign,
        ),
      },
      OrderItemState.waitingPaymentForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.uponYourPayment,
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.payment,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.waitForPayment,
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.cancel,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.waitForPayment,
          stateTextColor: AppColor.textYellow,
          operation: OrderOperationType.none,
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: isNormal ? S.current.waitBellePayDeposit : S.current.waitForPayment,
          stateTextColor: AppColor.yellow,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.waitYouPayGuaranteeFee,
          stateTextColor: AppColor.green,
          operation: OrderOperationType.payment,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.waitBellePayDeposit,
          stateTextColor: AppColor.yellow,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.none,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancel,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.cancelAndFinish,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.dateInProgress,
          stateTextColor: AppColor.textPurple,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.cancelForRequest: {
        UserType.user: OrderListItemWrapper(
          avatar: receiveAvatar,
          nick: "$receiveNamePrefix$receiveName",
          stateText: S.current.youCancelOrderVoluntarily,
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.theOtherPartyCancelledOrder,
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix$receiveName",
          stateText: S.current.userPartyCancelledOrder,
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.cancelForReceive: {
        UserType.user: OrderListItemWrapper(
          avatar: receiveAvatar,
          nick: "$receiveNamePrefix$receiveName",
          stateText: S.current.theOtherPartyCancelledOrder,
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.youCancelOrderVoluntarily,
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent:
              model.receiveId == 0 ? null : "$receiveNamePrefix$receiveName",
          stateText: S.current.bellePartyCancelledOrder,
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.timeOut: {
        UserType.user: OrderListItemWrapper(
          avatar: receiveAvatar,
          nick: "$receiveNamePrefix$receiveName",
          stateText: S.current.waitTimeout,
          stateTextColor: AppColor.black9,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.waitTimeout,
          stateTextColor: AppColor.black9,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: model.receiveId == 0
              ? null
              : "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.waitTimeout,
          stateTextColor: AppColor.black9,
          operation: OrderOperationType.connect,
        ),
      },
      OrderItemState.finish: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.orderCompleted,
          stateTextColor: AppColor.textGreen,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.orderCompleted,
          stateTextColor: AppColor.textGreen,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.orderCompleted,
          stateTextColor: AppColor.textGreen,
        ),
      },
      OrderItemState.waitingEvaluation: {
        UserType.user: OrderListItemWrapper(
          avatar: model.receiveAvatar,
          nick: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.confirmedCompletedEvaluated,
          stateTextColor: AppColor.textBlue,
          operation: OrderOperationType.evaluation,
        ),
        UserType.beauty: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          stateText: S.current.confirmedCompletedUserEvaluated,
          stateTextColor: AppColor.textGreen,
        ),
        UserType.agent: OrderListItemWrapper(
          avatar: model.requestAvatar,
          nick: "$requestNamePrefix${model.requestName}",
          nickWithAgent: "$receiveNamePrefix${model.receiveName}",
          stateText: S.current.confirmedCompletedUserEvaluated,
          stateTextColor: AppColor.textGreen,
        ),
      },
    };
  }

}
