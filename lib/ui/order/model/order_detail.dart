import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';

/// 订单详情具体类型包装器
class OrderDetailItemWrapper {
  final String title; // 标题
  final String detail; // 详情
  final String? avatar; // 用户头像

  OrderDetailItemWrapper({
    required this.title,
    required this.detail,
    this.avatar,
  });
}

/// 订单详情具体类型
class OrderDetailItem {
  OrderDetailItem({
    required this.model,
    required this.displayType,
    this.changeTitle,
    this.changeDetail,
    this.changeAvatar,
  }) {
    _wrapper = _getWrapper(
      model: model,
      displayType: displayType,
      changeTitle: changeTitle,
      changeDetail: changeDetail,
      changeAvatar: changeAvatar,
    );
  }

  // 原始数据
  final OrderItemModel model;

  // 订单展示类型
  final OrderDetailDisplayType displayType;

  // 改变标题
  final String? changeTitle;

  // 改变详情
  final String? changeDetail;

  // 改变头像
  final String? changeAvatar;

  // 包装器
  late final OrderDetailItemWrapper _wrapper;

  String get title => _wrapper.title;

  String get detail => _wrapper.detail;

  String? get avatar => _wrapper.avatar;

  static String _getTime(int time) {
    return CommonUtils.convertTimestampToString(time,
        newPattern: 'yyyy/MM/dd HH:mm');
  }

  static OrderDetailItemWrapper _getWrapper({
    required OrderItemModel model,
    required OrderDetailDisplayType displayType,
    String? changeTitle,
    String? changeDetail,
    String? changeAvatar,
  }) {
    switch (displayType) {
      case OrderDetailDisplayType.number:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.orderReference,
          detail: changeDetail ?? model.number,
        );
      case OrderDetailDisplayType.request:
        return OrderDetailItemWrapper(
          title: changeTitle ?? (model.type.isNormal ? S.current.orderUser : '${S.current.dating}：'),
          detail: changeDetail ?? model.requestName,
          avatar: changeAvatar ?? model.requestAvatar,
        );
      case OrderDetailDisplayType.receive:
        final receiveName =
            model.receiveId == 0 ? model.introducerName : model.receiveName;
        final receiveAvatar =
            model.receiveId == 0 ? model.introducerAvatar : model.receiveAvatar;

        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.incomingSubscriber,
          detail: changeDetail ?? receiveName,
          avatar: changeAvatar ?? receiveAvatar,
        );
      case OrderDetailDisplayType.requestTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.orderTime,
          detail: changeDetail ?? _getTime(model.createTime),
        );
      case OrderDetailDisplayType.receiveTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.orderReceivingTime,
          detail: changeDetail ?? _getTime(model.receiveTime),
        );
      case OrderDetailDisplayType.finishTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.endTime}：',
          detail: changeDetail ?? _getTime(model.completeTime),
        );
      case OrderDetailDisplayType.cancelTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.cancellationTime,
          detail: changeDetail ?? _getTime(model.cancelTime),
        );
      case OrderDetailDisplayType.reason:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '',
          detail: changeDetail ?? S.current.waitTimeout,
        );
      case OrderDetailDisplayType.margin:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.earnestMoney}：',
          detail: changeDetail ?? model.deposit.toString(),
        );
      case OrderDetailDisplayType.requestServiceFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.serviceCharge}：',
          detail: changeDetail ?? model.serviceCharge.toString(),
        );
      case OrderDetailDisplayType.breachFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.defaultMarginRatio,
          detail: changeDetail ??
              (model.exempt ? "0%" : "${model.proportionBreach.toString()}%"),
        );
      case OrderDetailDisplayType.breachFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.liquidatedDamages,
          detail: changeDetail ??
              (model.exempt ? S.current.VIPExemption : model.breachAmount.toString()),
        );
      case OrderDetailDisplayType.platformFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.platformChargeRatio}：',
          detail: "${changeDetail ?? model.proportionPlatform.toString()}%",
        );
      case OrderDetailDisplayType.platformFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.platformFee}：',
          detail: changeDetail ?? model.platformAmount.toString(),
        );
      case OrderDetailDisplayType.receiveFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.beautyServiceFee,
          detail: changeDetail ?? model.beautyAmount.toString(),
        );
      case OrderDetailDisplayType.receiveFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.rateOfCharge,
          detail: "${changeDetail ?? model.proportionBeauty.toString()}%",
        );
      case OrderDetailDisplayType.agentFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '${S.current.agentChargeRatio}：',
          detail: "${changeDetail ?? model.proportionBroker.toString()}%",
        );
      case OrderDetailDisplayType.agentFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.brokerFee,
          detail: changeDetail ?? model.brokerAmount.toString(),
        );
      case OrderDetailDisplayType.amount:
        return OrderDetailItemWrapper(
          title: changeTitle ?? S.current.amountPaid,
          detail: changeDetail ??
              (model.exempt
                  ? "0"
                  : (model.deposit + model.serviceCharge).toString()),
        );
    }
  }
}

/// 订单详情包装器
class OrderDetailWrapper {
  OrderDetailWrapper({
    required this.stateText,
    required this.stateDetailText,
    required this.upDisplayTypes,
    this.downDisplayTypes = const [],
    this.hasCancel = false,
    this.hasDivider = false,
    this.bottomTipText,
    this.operation = OrderOperationType.none,
  });

  final String stateText; // 订单状态文本
  final String stateDetailText; // 订单状态下方文本
  final List<OrderDetailItem> upDisplayTypes; // 顶部订单展示类型列表
  final List<OrderDetailItem> downDisplayTypes; // 底部订单展示类型列表
  final bool hasCancel; // 是否有取消
  final bool hasDivider; // 是否有分割线
  final String? bottomTipText; // 底部提醒文本
  final OrderOperationType operation; // 订单操作类型
}

/// 订单详情模型组装
class OrderDetail {
  OrderDetail({
    required this.itemModel,
  }) {
    itemType = OrderListItem.getType(itemModel);
    _wrapper = _getWrapper(itemModel, itemType);
  }

  // 原始数据
  final OrderItemModel itemModel;

  // 订单类型
  late final OrderItemState itemType;

  // 订单详情界面包装器
  late final OrderDetailWrapper _wrapper;

  // 订单id
  int get id => itemModel.id;

  // 订单状态文本
  String get stateText => _wrapper.stateText;

  // 订单状态下方文本
  String get stateDetailText => _wrapper.stateDetailText;

  // 顶部订单展示类型列表
  List<OrderDetailItem> get upDisplayTypes => _wrapper.upDisplayTypes;

  // 底部订单展示类型列表
  List<OrderDetailItem> get downDisplayTypes => _wrapper.downDisplayTypes;

  // 是否有取消
  bool get hasCancel => _wrapper.hasCancel;

  // 是否有分割线
  bool get hasDivider => _wrapper.hasDivider;

  // 底部提醒文本
  String? get bottomTipText => _wrapper.bottomTipText;

  // 订单操作类型
  OrderOperationType get operation => _wrapper.operation;

  /// 根据订单类型和状态进行组装
  static OrderDetailWrapper _getWrapper(
    OrderItemModel model,
    OrderItemState state,
  ) {
    // TODO: 目前需求全部使用普通订单用户类型去封装，目前只有少数字段显示不同，后续有需要再细分
    final userId = SS.login.userId;
    final userType = userId == model.requestId
        ? UserType.user
        : userId == model.receiveId
            ? UserType.beauty
            : UserType.agent;

    final OrderDetailWrapper? wrapper =
        buildNormalWrapperMap(model)[state]?[userType];

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
        OrderDetailWrapper(
          stateText: "",
          stateDetailText: "",
          upDisplayTypes: [],
        );
  }

  static Map<OrderItemState, Map<UserType, OrderDetailWrapper>>
      buildNormalWrapperMap(OrderItemModel model) {
    final isNormal = model.type.isNormal;
    return {
      OrderItemState.waitingAcceptance: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.waitingBelleOrder,
          stateDetailText: S.current.belleTakingOrder,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.number,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.waitingListMiss,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.requestTime,
            ),
          ],
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.waitingYourOrder,
          stateDetailText: S.current.afterReceivingOrder,
          hasCancel: true,
          operation: OrderOperationType.accept,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
          ],
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.waitingBelleOrder,
          stateDetailText: S.current.belleTakingOrder,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.waitingListMiss,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
          ],
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.waitingYourOrder,
          stateDetailText: S.current.afterReceivingOrder,
          hasCancel: true,
          operation: OrderOperationType.assign,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
          ],
        ),
      },
      OrderItemState.waitingPaymentForRequest: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.waitYouPayFee,
          stateDetailText: S.current.depositReturned,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
          operation: OrderOperationType.payment,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.waitUserPayFee,
          stateDetailText: S.current.bothPartiesWillReturned,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.waitUserPayFee,
          stateDetailText: S.current.bothPartiesWillReturned,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
        ),
      },
      OrderItemState.waitingPaymentForReceive: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.waitBellePayFee,
          stateDetailText: S.current.afterPaymentBegin,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "${S.current.waitYouPayGuaranteeFee}···",
          stateDetailText: S.current.afterPaymentTheBegin,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
          operation: OrderOperationType.payment,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.waitBellePayFee,
          stateDetailText: S.current.bothPartiesWillReturned,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
        ),
      },
      OrderItemState.waitingConfirmForRequest: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? S.current.orderReceivingBelle : S.current.goOnADate,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.amount),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.requestServiceFee,
              changeTitle: S.current.userPaysServiceFee,
            ),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.agentFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.agentFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.receivableAmount,
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFeeProportion,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFee,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.receivableAmount,
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.amount),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.requestServiceFee,
              changeTitle: S.current.userPaysServiceFee,
            ),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.agentFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.agentFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.receivableAmount,
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
          operation: OrderOperationType.cancelAndFinish,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.orderInProgress,
          stateDetailText: S.current.serviceFeeReturnedBelle,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFeeProportion,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFee,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.receivableAmount,
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
      },
      OrderItemState.cancelForRequest: () {
        // 目前通过双方是否存在支付时间来判断取消是在哪个阶段取消的
        final isCancelGoingAfter =
            model.requestPayTime != 0 && model.receivePayTime != 0;
        if (isCancelGoingAfter) {
          return {
            UserType.user: OrderDetailWrapper(
              stateText: S.current.orderCancelled,
              stateDetailText: S.current.serviceFeeBeenReturned,
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: S.current.orderReceivingBelle,
                ),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receiveTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.cancelTime),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.reason,
                  changeDetail: S.current.youCancelOrderVoluntarily,
                ),
              ],
              hasDivider: true,
              downDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.margin),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestServiceFee,
                ),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.breachFeeProportion,
                ),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.breachFee,
                ),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.amount,
                  changeDetail: model.exempt
                      ? "0"
                      :  model.breachAmount.toString(),
                ),
              ],
              bottomTipText: S.current.duringTheAppointment(model.proportionBreach),
            ),
            UserType.beauty: OrderDetailWrapper(
              stateText: S.current.orderCancelled,
              stateDetailText: S.current.beenReturnedTheOriginalWay,
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.request),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receiveTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.cancelTime),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.reason,
                  changeDetail: S.current.userCancelsOrder,
                ),
              ],
              bottomTipText: S.current.theOtherPartyCancelsTheOrder,
            ),
            UserType.agent: OrderDetailWrapper(
              stateText: S.current.orderCancelled,
              stateDetailText: S.current.depositAndServiceChargeReturned,
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.request),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: S.current.orderReceivingBelle,
                ),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.cancelTime),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.reason,
                  changeDetail: S.current.userCancelsOrder,
                ),
              ],
              bottomTipText: S.current.duringTheAppointment(model.proportionBreach),
            ),
          };
        }
        return {
          UserType.user: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.serviceFeeBeenReturned,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: S.current.orderReceivingBelle,
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.youCancelOrderVoluntarily,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
          UserType.beauty: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.beenReturnedTheOriginalWay,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.userCancelsOrder,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
          UserType.agent: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.depositAndServiceChargeReturned,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: S.current.orderReceivingBelle,
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.userCancelsOrder,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
        };
      }(),
      OrderItemState.cancelForReceive: () {
        // 目前通过双方是否存在支付时间来判断取消是在哪个阶段取消的
        final isCancelGoingAfter =
            model.requestPayTime != 0 && model.receivePayTime != 0;
        if (isCancelGoingAfter) {
          return {
            UserType.user: OrderDetailWrapper(
              stateText: S.current.orderCancelled,
              stateDetailText: S.current.serviceFeeBeenReturned,
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: S.current.orderReceivingBelle,
                ),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receiveTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.cancelTime),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.reason,
                  changeDetail: S.current.belleCancelsVoluntarily,
                ),
              ],
              bottomTipText: S.current.theOtherPartyCancelsTheOrder,
            ),
            UserType.beauty: OrderDetailWrapper(
              stateText: S.current.orderCancelled,
              stateDetailText: S.current.beenReturnedTheOriginalWay,
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.request),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receiveTime),
                OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.cancelTime),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.reason,
                  changeDetail: S.current.youCancelOrderVoluntarily,
                ),
              ],
              hasDivider: true,
              downDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.margin),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.breachFeeProportion,
                ),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.breachFee,
                ),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.amount,
                  changeDetail: model.exempt
                      ? "0"
                      : model.breachAmount.toString(),
                ),
              ],
              bottomTipText: S.current.duringTheAppointment(model.proportionBreach),
            ),
            UserType.agent: OrderDetailWrapper(
                stateText: S.current.orderCancelled,
                stateDetailText: S.current.depositAndServiceChargeReturned,
                upDisplayTypes: [
                  OrderDetailItem(
                      model: model, displayType: OrderDetailDisplayType.number),
                  OrderDetailItem(
                      model: model,
                      displayType: OrderDetailDisplayType.request),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receive,
                    changeTitle: S.current.orderReceivingBelle,
                  ),
                  OrderDetailItem(
                      model: model,
                      displayType: OrderDetailDisplayType.requestTime),
                  OrderDetailItem(
                      model: model,
                      displayType: OrderDetailDisplayType.receiveTime),
                  OrderDetailItem(
                      model: model,
                      displayType: OrderDetailDisplayType.cancelTime),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.reason,
                    changeDetail: S.current.belleCancelsOrder,
                  ),
                ],
                hasDivider: true,
                downDisplayTypes: [
                  OrderDetailItem(
                      model: model, displayType: OrderDetailDisplayType.margin),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.requestServiceFee,
                  ),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.breachFeeProportion,
                  ),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.breachFee,
                  ),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.amount,
                    changeTitle: S.current.beautifulAmount,
                    changeDetail: model.exempt
                        ? "0"
                        : model.breachAmount.toString(),
                  ),
                ],
              bottomTipText: S.current.duringTheAppointment(model.proportionBreach),
            ),
          };
        }
        return {
          UserType.user: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.serviceFeeBeenReturned,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: S.current.orderReceivingBelle,
                changeAvatar:
                    model.receiveId == 0 ? model.introducerAvatar : null,
                changeDetail:
                    model.receiveId == 0 ? model.introducerName : null,
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.belleCancelsOrder,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
          UserType.beauty: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.beenReturnedTheOriginalWay,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.youCancelOrderVoluntarily,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
          UserType.agent: OrderDetailWrapper(
            stateText: S.current.orderCancelled,
            stateDetailText: S.current.depositAndServiceChargeReturned,
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: S.current.orderReceivingBelle,
                changeAvatar:
                    model.receiveId == 0 ? model.introducerAvatar : null,
                changeDetail:
                    model.receiveId == 0 ? model.introducerName : null,
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: S.current.belleCancelsOrder,
              ),
            ],
            bottomTipText: S.current.theOrderHasBeenCancelled,
          ),
        };
      }(),
      OrderItemState.timeOut: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.orderCancelled,
          stateDetailText: S.current.serviceFeeBeenReturned,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
              changeAvatar:
                  model.receiveId == 0 ? model.introducerAvatar : null,
              changeDetail: model.receiveId == 0 ? model.introducerName : null,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.cancelTime),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.reason,
              changeDetail: S.current.waitTimeout,
            ),
          ],
          bottomTipText: S.current.theOrderHasBeenCancelled,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.orderCancelled,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.cancelTime),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.reason,
              changeDetail: S.current.waitTimeout,
            ),
          ],
          bottomTipText: S.current.theOrderHasBeenCancelled,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.orderCancelled,
          stateDetailText: S.current.depositAndServiceChargeReturned,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
              changeAvatar:
                  model.receiveId == 0 ? model.introducerAvatar : null,
              changeDetail: model.receiveId == 0 ? model.introducerName : null,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.cancelTime),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.reason,
              changeDetail: S.current.waitTimeout,
            ),
          ],
          bottomTipText: S.current.theOrderHasBeenCancelled,
        ),
      },
      OrderItemState.finish: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.orderCompleted,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.margin,
              changeTitle: S.current.marginReturn,
            ),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeDetail: model.serviceCharge.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.orderCompleted,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee,
                changeTitle: S.current.userPaysServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.agentFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.agentFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.fundsReceived,
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.orderCompleted,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee,
                changeTitle: S.current.userPaysServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFeeProportion,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFee,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.fundsReceived,
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
        ),
      },
      OrderItemState.waitingEvaluation: {
        UserType.user: OrderDetailWrapper(
          stateText: S.current.completedPendingEvaluation,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.margin,
              changeTitle: S.current.marginReturn,
            ),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeDetail: model.serviceCharge.toString(),
            ),
          ],
          bottomTipText: S.current.depositReturnedAccountCompleted,
          operation: OrderOperationType.evaluation,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: S.current.completedPendingUserEvaluation,
          stateDetailText: S.current.beenReturnedTheOriginalWay,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee,
                changeTitle: S.current.userPaysServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.agentFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.agentFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.fundsReceived,
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: S.current.completedPendingUserEvaluation,
          stateDetailText: S.current.pleaseCheckAccount,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: S.current.orderReceivingBelle,
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.finishTime),
          ],
          hasDivider: true,
          downDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.margin),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.requestServiceFee,
                changeTitle: S.current.userPaysServiceFee),
            OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.platformFeeProportion),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.platformFee),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFeeProportion,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receiveFee,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: S.current.fundsReceived,
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
        ),
      },
    };
  }

}
