import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/mine_controller.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/widgets/widgets.dart';

///约会状态View（显示在消息列表顶部）
class ChatDateView extends StatelessWidget {
  static double get height => 66.rpx;

  final UserModel user;
  final OrderItemModel? order;

  ///点击订单操作
  final void Function(OrderOperationType operation, OrderItemModel? order)?
      onTapOrderAction;

  ///点击订单详情
  final void Function(OrderItemModel order)? onTapOrder;

  //是否来自征友页面
  final bool isFriendDate;

  const ChatDateView({
    super.key,
    required this.user,
    required this.isFriendDate,
    this.order,
    this.onTapOrderAction,
    this.onTapOrder,
  });

  ///普通订单UI状态
  Map<OrderItemState, Map<UserType, _UIState>> get _uiStateNormal {
    return {
      OrderItemState.waitingAcceptance: {
        UserType.user: _UIState(
          desc: '佳丽正在接单中，请您耐心等待',
        ),
        UserType.beauty: _UIState(
          desc: '当前用户向您发起了约会请求，请注意及时接单哦～',
          button: '立即接单',
          operation: OrderOperationType.accept,
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: _UIState(
          desc: '当前用户向您发起了约会请求，请注意及时接单哦～',
          button: '指派接单',
          operation: OrderOperationType.assign,
        ),
      },
      OrderItemState.waitingPaymentForRequest: {
        UserType.user: _UIState(
          desc: '佳丽已接单，请您及时缴纳保证金和服务费',
          button: '立即缴纳',
          operation: OrderOperationType.payment,
        ),
        UserType.beauty: _UIState(
          desc: '用户正在缴纳保证金和服务费，请您耐心等待',
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        UserType.user: _UIState(
          desc: '佳丽正在缴纳保证金，请您耐心等待',
        ),
        UserType.beauty: _UIState(
          desc: '您已接单，请您及时缴纳保证金',
          button: '立即缴纳',
          operation: OrderOperationType.payment,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: _UIState(
          desc: '约会已开始',
        ),
        UserType.beauty: _UIState(
          desc: '点击“我已到位”，约会便正式开始哦～',
          button: '我已到位',
          operation: OrderOperationType.confirm,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        UserType.user: _UIState(
          desc: '约会已开始，约会结束后记得点击右侧按钮结束订单哦～',
          button: '确认完成订单',
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: _UIState(desc: '约会已开始'),
      },
    };
  }

  ///征友订单UI状态
  Map<OrderItemState, Map<OrderItemUserType, _UIState>> get _uiStateFriend {
    return {
      OrderItemState.waitingPaymentForRequest: {
        OrderItemUserType.request: _UIState(
          desc: '对方已参与您的征友约会，请您及时缴纳保证金和服务费',
          button: '立即缴纳',
          operation: OrderOperationType.payment,
        ),
        OrderItemUserType.receive: _UIState(
          desc: '对方正在缴纳保证金和服务费，请您耐心等待',
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        OrderItemUserType.request: _UIState(
          desc: '对方正在缴纳保证金和服务费，请您耐心等待',
        ),
        OrderItemUserType.receive: _UIState(
          desc: '您已参与Ta的征友约会，请您及时缴纳保证金',
          button: '立即缴纳',
          operation: OrderOperationType.payment,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        OrderItemUserType.request: _UIState(
          desc: '约会已开始',
        ),
        OrderItemUserType.receive: _UIState(
          desc: '点击“我已到位”，约会便正式开始哦～',
          button: '我已到位',
          operation: OrderOperationType.confirm,
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        OrderItemUserType.request: _UIState(
          desc: '约会已开始，约会结束后记得点击右侧按钮结束订单哦～',
          button: '确认完成订单',
          operation: OrderOperationType.finish,
        ),
        OrderItemUserType.receive: _UIState(desc: '约会已开始'),
      },
    };
  }

  ///获取订单UI状态
  _UIState? _getUIState(final OrderItemModel? order, UserModel? selfUser) {

    //对方用户类型
    final targetType = user.type;

    //当前登录用户类型
    final selfType = selfUser?.type ?? UserType.user;

    //双方都是佳丽或者经纪人,不显示
    if (!targetType.isUser && !selfType.isUser) {
      return null;
    }

    if (order == null ||
        [OrderState.finish, OrderState.cancel].contains(order.state)) {
      //订单为空，或者订单已完结 佳丽和经纪人不显示发起约会
      if (selfType.isUser && !targetType.isUser) {
        return _UIState(
          desc: '点击右侧按钮，发起约会吧！',
          button: '发起约会',
          operation: OrderOperationType.create,
        );
      }

      //订单为空，或者订单已完结，佳丽尚未开启接单的情况下，显示接单提示
      if (selfType.isBeauty &&
          targetType.isUser &&
          selfUser?.state == UserStatus.offline) {
        return _UIState(
          icon: 'assets/images/chat/ic_offline_tips.png',
          desc: '您当前处于“不接约”状态，请注意及时调整。',
          button: '上线接约',
          onTap: () {
            Get.tryFind<MineController>()
                ?.onTapBeautifulStatus(UserStatus.online);
          },
        );
      }
      return null;
    }

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

  @override
  Widget build(BuildContext context) {
    return Obx((){
      final uiState = _getUIState(order, SS.login.info);
      if (uiState == null) {
        return Spacing.blank;
      }
      return GestureDetector(
        onTap: () {
          if (order != null &&
              ![OrderState.cancel, OrderState.finish].contains(order?.state)) {
            onTapOrder?.call(order!);
          }
        },
        child: Container(
          height: ChatDateView.height,
          color: AppColor.grayF7,
          padding: FEdgeInsets(horizontal: 16.rpx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  uiState.desc,
                  textAlign:
                  uiState.button != null ? TextAlign.left : TextAlign.center,
                  style: AppTextStyle.fs14m.copyWith(
                    color: AppColor.gray5,
                  ),
                ),
              ),
              if (uiState.button != null)
                Padding(
                  padding: FEdgeInsets(left: 16.rpx),
                  child: CommonGradientButton(
                    onTap: (){
                      onTapOrderAction?.call(uiState.operation, order);
                      uiState.onTap?.call();
                    },
                    height: 37.rpx,
                    padding: FEdgeInsets(horizontal: 16.rpx),
                    borderRadius: BorderRadius.zero,
                    text: uiState.button,
                    textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _UIState {
  final String? icon;

  ///描述文本
  final String desc;

  ///按钮文本
  final String? button;

  ///按钮操作
  final OrderOperationType operation;

  ///按钮操作
  final VoidCallback? onTap;

  _UIState({
    this.icon,
    required this.desc,
    this.button,
    this.operation = OrderOperationType.none,
    this.onTap,
  });
}
