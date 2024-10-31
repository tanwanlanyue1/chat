import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_controller.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///约会状态View（显示在消息列表顶部）
class ChatDateView extends StatelessWidget with UIOrderStateMixin {
  static double get height => 60.rpx;

  final UserModel user;
  final OrderItemModel? order;

  ///点击订单操作
  final void Function(OrderOperationType operation, OrderItemModel? order)?
      onTapOrderAction;

  ///点击订单详情
  final void Function(OrderItemModel order)? onTapOrder;

  const ChatDateView({
    super.key,
    required this.user,
    this.order,
    this.onTapOrderAction,
    this.onTapOrder,
  });

  ///获取订单UI状态
  UIOrderState? _getUIState(final OrderItemModel? order, UserModel? selfUser) {
    //对方用户类型
    final targetType = user.type;

    //当前登录用户类型
    final selfType = selfUser?.type ?? UserType.user;

    //双方都是佳丽或者经纪人,不显示
    if (!targetType.isUser && !selfType.isUser) {
      return null;
    }

    if (order == null ||
        [OrderStatus.finish, OrderStatus.cancel, OrderStatus.timeOut]
            .contains(order.state)) {
      //订单为空，或者订单已完结 佳丽和经纪人不显示发起约会
      if (selfType.isUser && !targetType.isUser) {
        return UIOrderState(
          desc: S.current.chatDateCreate,
          button: S.current.initiateAppointment,
          operation: OrderOperationType.create,
        );
      }

      //订单为空，或者订单已完结，佳丽尚未开启接单的情况下，显示接单提示
      if (selfType.isBeauty &&
          targetType.isUser &&
          selfUser?.state == UserStatus.offline) {
        return UIOrderState(
          icon: 'assets/images/chat/ic_offline_tips.png',
          desc: S.current.dateModeOpenHint,
          button: S.current.onLineEngagement,
          buttonColor: AppColor.dateButton,
          onTap: () {
            Get.tryFind<MineController>()
                ?.onTapBeautifulStatus(UserStatus.online);
          },
        );
      }
      return null;
    }
    return getUIOrderState(order);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7F9),
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Obx(() {
        final uiState = _getUIState(order, SS.login.info);
        if (uiState == null) {
          return Spacing.blank;
        }
        return GestureDetector(
          onTap: () {
            if (order != null &&
                ![OrderStatus.cancel, OrderStatus.finish, OrderStatus.timeOut]
                    .contains(order?.state)) {
              onTapOrder?.call(order!);
            }
          },
          child: Container(
            height: ChatDateView.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: Colors.white,
            ),
            padding: FEdgeInsets(horizontal: 12.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (uiState.icon != null)
                  Padding(
                    padding: FEdgeInsets(right: 4.rpx, bottom: 12.rpx),
                    child: AppImage.asset(
                      uiState.icon ?? '',
                      width: 16.rpx,
                      height: 16.rpx,
                    ),
                  ),
                Expanded(
                  child: Text(
                    uiState.desc,
                    textAlign: uiState.button != null
                        ? TextAlign.left
                        : TextAlign.center,
                    style: AppTextStyle.fs14.copyWith(
                      color: AppColor.blackBlue,
                      height: 1.2,
                    ),
                  ),
                ),
                if (uiState.button != null)
                  Padding(
                    padding: FEdgeInsets(left: 12.rpx),
                    child: CommonGradientButton(
                      onTap: () {
                        onTapOrderAction?.call(uiState.operation, order);
                        uiState.onTap?.call();
                      },
                      height: 30.rpx,
                      padding: FEdgeInsets(horizontal: 10.rpx),
                      borderRadius: BorderRadius.circular(15.rpx),
                      text: uiState.button,
                      backgroundColor: uiState.buttonColor,
                      textStyle: AppTextStyle.fs14.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

mixin UIOrderStateMixin {
  ///普通订单UI状态
  Map<OrderItemState, Map<UserType, UIOrderState>> get _uiStateNormal {
    return {
      OrderItemState.waitingAcceptance: {
        UserType.user: UIOrderState(
          desc: S.current.beautyReceivingOrder,
        ),
        UserType.beauty: UIOrderState(
          desc: S.current.orderTakingTips,
          button: S.current.immediateOrder,
          operation: OrderOperationType.accept,
          isCountdown: true,
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: UIOrderState(
          desc: S.current.orderTakingTips,
          button: S.current.assignmentOfOrder,
          operation: OrderOperationType.assign,
          isCountdown: true,
        ),
      },
      OrderItemState.waitingPaymentForRequest: {
        UserType.user: UIOrderState(
          desc: S.current.depositForUser,
          button: S.current.depositNow,
          operation: OrderOperationType.payment,
          isCountdown: true,
        ),
        UserType.beauty: UIOrderState(
          desc: S.current.depositBeingPaidForUser,
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        UserType.user: UIOrderState(
          desc: S.current.depositBeingPaidForBeauty,
        ),
        UserType.beauty: UIOrderState(
          desc: S.current.depositBeingPaid,
          button: S.current.depositNow,
          operation: OrderOperationType.payment,
          isCountdown: true,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: UIOrderState(
          desc: S.current.dateBegin,
        ),
        UserType.beauty: UIOrderState(
          desc: S.current.beautyReadyHint,
          button: S.current.imInPlace,
          operation: OrderOperationType.confirm,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        UserType.user: UIOrderState(
          desc: S.current.dateFinishHint,
          button: S.current.completeOrder,
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: UIOrderState(desc: S.current.dateBegin),
      },
      OrderItemState.cancelForRequest: {
        UserType.user: UIOrderState(desc: S.current.dateOrderCanceled),
        UserType.beauty: UIOrderState(desc: S.current.dateOrderCanceled),
        UserType.agent: UIOrderState(desc: S.current.dateOrderCanceled),
      },
      OrderItemState.cancelForReceive: {
        UserType.user: UIOrderState(desc: S.current.dateOrderCanceled),
        UserType.beauty: UIOrderState(desc: S.current.dateOrderCanceled),
        UserType.agent: UIOrderState(desc: S.current.dateOrderCanceled),
      },
      OrderItemState.timeOut: {
        UserType.user: UIOrderState(desc: S.current.dateOrderTimeout),
        UserType.beauty: UIOrderState(desc: S.current.dateOrderTimeout),
        UserType.agent: UIOrderState(desc: S.current.dateOrderTimeout),
      },
      OrderItemState.waitingEvaluation: {
        UserType.user: UIOrderState(desc: S.current.dateOrderCompletedHint),
        UserType.beauty:
            UIOrderState(desc: S.current.dateOrderCompletedHintForUser),
        UserType.agent:
            UIOrderState(desc: S.current.dateOrderCompletedHintForUser),
      },
      OrderItemState.finish: {
        UserType.user: UIOrderState(desc: S.current.youHaveRated),
        UserType.beauty: UIOrderState(desc: S.current.userHaveRated),
        UserType.agent: UIOrderState(desc: S.current.userHaveRated),
      },
    };
  }

  ///征友订单UI状态
  Map<OrderItemState, Map<OrderItemUserType, UIOrderState>> get _uiStateFriend {
    return {
      OrderItemState.waitingPaymentForRequest: {
        OrderItemUserType.request: UIOrderState(
          desc: S.current.friendDeposit,
          button: S.current.depositNow,
          operation: OrderOperationType.payment,
          isCountdown: true,
        ),
        OrderItemUserType.receive: UIOrderState(
          desc: S.current.friendDepositBeingPaidForUser,
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        OrderItemUserType.request: UIOrderState(
          desc: S.current.friendDepositBeingPaidForUser,
        ),
        OrderItemUserType.receive: UIOrderState(
          desc: S.current.friendDepositBeingPaid,
          button: S.current.depositNow,
          operation: OrderOperationType.payment,
          isCountdown: true,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        OrderItemUserType.request: UIOrderState(
          desc: S.current.dateBegin,
        ),
        OrderItemUserType.receive: UIOrderState(
          desc: S.current.beautyReadyHint,
          button: S.current.imInPlace,
          operation: OrderOperationType.confirm,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        OrderItemUserType.request: UIOrderState(
          desc: S.current.dateFinishHint,
          button: S.current.completeOrder,
          operation: OrderOperationType.finish,
        ),
        OrderItemUserType.receive: UIOrderState(desc: S.current.dateBegin),
      },
      OrderItemState.cancelForRequest: {
        OrderItemUserType.request:
            UIOrderState(desc: S.current.dateOrderCanceled),
        OrderItemUserType.receive:
            UIOrderState(desc: S.current.dateOrderCanceled),
      },
      OrderItemState.cancelForReceive: {
        OrderItemUserType.request:
            UIOrderState(desc: S.current.dateOrderCanceled),
        OrderItemUserType.receive:
            UIOrderState(desc: S.current.dateOrderCanceled),
      },
      OrderItemState.timeOut: {
        OrderItemUserType.request:
            UIOrderState(desc: S.current.dateOrderTimeout),
        OrderItemUserType.receive:
            UIOrderState(desc: S.current.dateOrderTimeout),
      },
      OrderItemState.finish: {
        OrderItemUserType.request:
            UIOrderState(desc: S.current.dateOrderCompleted),
        OrderItemUserType.receive:
            UIOrderState(desc: S.current.dateOrderCompleted),
      },
    };
  }

  ///获取订单UI状态
  UIOrderState? getUIOrderState(final OrderItemModel order) {
    final orderState = OrderListItem.getType(order);
    if (order.type.isNormal) {
      final userId = SS.login.userId;
      final userType = userId == order.requestId
          ? UserType.user
          : userId == order.receiveId
              ? UserType.beauty
              : UserType.agent;
      return _uiStateNormal[orderState]?[userType];
    } else {
      final userType = order.requestId == SS.login.userId
          ? OrderItemUserType.request
          : OrderItemUserType.receive;
      return _uiStateFriend[orderState]?[userType];
    }
  }
}

class UIOrderState {
  final String? icon;

  ///描述文本
  final String desc;

  ///按钮文本
  final String? button;

  ///按钮颜色
  final Color? buttonColor;

  ///按钮操作
  final OrderOperationType operation;

  ///按钮操作
  final VoidCallback? onTap;

  ///是否显示倒计时
  final bool isCountdown;

  UIOrderState({
    this.icon,
    required this.desc,
    this.button,
    this.buttonColor,
    this.operation = OrderOperationType.none,
    this.onTap,
    this.isCountdown = false,
  });
}
