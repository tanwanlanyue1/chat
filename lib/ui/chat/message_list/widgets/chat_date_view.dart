import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/widgets/order_create_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

///约会状态View（显示在消息列表顶部）
class ChatDateView extends StatefulWidget {
  final UserModel user;
  final OrderItemModel? order;

  //是否来自征友页面
  final bool isFriendDate;

  const ChatDateView({
    super.key,
    required this.user,
    required this.isFriendDate,
    this.order,
  });

  static double get height => 66.rpx;

  @override
  State<ChatDateView> createState() => _ChatDateViewState();
}

class _ChatDateViewState extends State<ChatDateView> with OrderOperationMixin {

  ///对方用户类型
  late UserType targetType;

  ///当前登录用户类型
  late UserType selfType;

  @override
  void initState() {
    super.initState();
    targetType = widget.user.type;
    selfType = SS.login.userType;
  }

  Map<OrderItemState, Map<UserType, _UIState>> get uiStateMap {
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

  _UIState? getUIState(final OrderItemModel? order){

    //双方都是佳丽或者经纪人,不显示
    if (!targetType.isUser && !selfType.isUser) {
      return null;
    }

    //订单为空，佳丽和经纪人不显示
    if(order == null){
      if(selfType.isUser && !targetType.isUser){
        return  _UIState(
          desc: '点击右侧按钮，发起约会吧！',
          button: '发起约会',
          operation: OrderOperationType.create,
        );
      }
      return null;
    }

    final userId = SS.login.userId;
    final userType = userId == order.requestId
        ? UserType.user
        : userId == order.receiveId
        ? UserType.beauty
        : UserType.agent;
    final orderState = OrderListItem.getType(order);
    return uiStateMap[orderState]?[userType];
  }


  @override
  Widget build(BuildContext context) {
    final uiState = getUIState(widget.order);
    if (uiState == null) {
      return Spacing.blank;
    }
    return Container(
      height: ChatDateView.height,
      color: AppColor.grayF7,
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              uiState.desc,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
          if(uiState.button != null) Padding(
            padding: FEdgeInsets(left: 16.rpx),
            child: CommonGradientButton(
              onTap: () => onTap(uiState.operation),
              height: 37.rpx,
              padding: FEdgeInsets(horizontal: 16.rpx),
              borderRadius: BorderRadius.zero,
              text: uiState.button,
              textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void onTap(OrderOperationType operation){
    switch(operation){
      case OrderOperationType.none:
        // TODO: Handle this case.
      case OrderOperationType.create:
        OrderCreateDialog.show(userId: widget.user.uid);
      case OrderOperationType.accept:
        // TODO: Handle this case.
      case OrderOperationType.assign:
        // TODO: Handle this case.
      case OrderOperationType.payment:
        // TODO: Handle this case.
      case OrderOperationType.confirm:
        // TODO: Handle this case.
      case OrderOperationType.cancel:
        // TODO: Handle this case.
      case OrderOperationType.cancelAndFinish:
        // TODO: Handle this case.
      case OrderOperationType.finish:
        // TODO: Handle this case.
      case OrderOperationType.connect:
        // TODO: Handle this case.
      case OrderOperationType.evaluation:
        // TODO: Handle this case.
    }
  }
}

class _UIState {
  ///描述文本
  final String desc;

  ///按钮文本
  final String? button;

  ///按钮操作
  final OrderOperationType operation;

  _UIState({
    required this.desc,
    this.button,
    this.operation = OrderOperationType.none,
  });
}
