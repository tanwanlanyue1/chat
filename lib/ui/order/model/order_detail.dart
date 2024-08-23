import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
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
          title: changeTitle ?? '订单编号：',
          detail: changeDetail ?? model.number,
        );
      case OrderDetailDisplayType.request:
        return OrderDetailItemWrapper(
          title: changeTitle ?? (model.type.isNormal ? '下单用户：' : '征友约会：'),
          detail: changeDetail ?? model.requestName,
          avatar: changeAvatar ?? model.requestAvatar,
        );
      case OrderDetailDisplayType.receive:
        final receiveName =
            model.receiveId == 0 ? model.introducerName : model.receiveName;
        final receiveAvatar =
            model.receiveId == 0 ? model.introducerAvatar : model.receiveAvatar;

        return OrderDetailItemWrapper(
          title: changeTitle ?? '接单用户：',
          detail: changeDetail ?? receiveName,
          avatar: changeAvatar ?? receiveAvatar,
        );
      case OrderDetailDisplayType.requestTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '下单时间：',
          detail: changeDetail ?? _getTime(model.createTime),
        );
      case OrderDetailDisplayType.receiveTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '接单时间：',
          detail: changeDetail ?? _getTime(model.receiveTime),
        );
      case OrderDetailDisplayType.finishTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '结束时间：',
          detail: changeDetail ?? _getTime(model.completeTime),
        );
      case OrderDetailDisplayType.cancelTime:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '取消时间：',
          detail: changeDetail ?? _getTime(model.cancelTime),
        );
      case OrderDetailDisplayType.reason:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '',
          detail: changeDetail ?? '等待超时',
        );
      case OrderDetailDisplayType.margin:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '保证金：',
          detail: changeDetail ?? model.deposit.toString(),
        );
      case OrderDetailDisplayType.requestServiceFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '服务费：',
          detail: changeDetail ?? model.serviceCharge.toString(),
        );
      case OrderDetailDisplayType.breachFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '违约收取保证金比例：',
          detail: "${changeDetail ?? model.proportionBreach.toString()}%",
        );
      case OrderDetailDisplayType.breachFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '违约金：',
          detail: changeDetail ?? model.breachAmount.toString(),
        );
      case OrderDetailDisplayType.platformFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '平台收取比例：',
          detail: "${changeDetail ?? model.proportionPlatform.toString()}%",
        );
      case OrderDetailDisplayType.platformFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '平台费：',
          detail: changeDetail ?? model.platformAmount.toString(),
        );
      case OrderDetailDisplayType.receiveFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '佳丽收取比例：',
          detail: "${changeDetail ?? model.proportionBroker.toString()}%",
        );
      case OrderDetailDisplayType.agentFeeProportion:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '经纪人收取比例：',
          detail: "${changeDetail ?? model.proportionBroker.toString()}%",
        );
      case OrderDetailDisplayType.agentFee:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '经纪人介绍费：',
          detail: changeDetail ?? model.brokerAmount.toString(),
        );
      case OrderDetailDisplayType.amount:
        return OrderDetailItemWrapper(
          title: changeTitle ?? '实付金额：',
          detail:
              changeDetail ?? (model.deposit + model.serviceCharge).toString(),
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
          stateText: "等待佳丽接单中···",
          stateDetailText: "佳丽正在接单中，请耐心等待哦~",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.number,
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "待接单佳丽：",
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.requestTime,
            ),
          ],
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "等待您接单中···",
          stateDetailText: "接单后，用户才能缴纳费用哦~",
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
          stateText: "等待佳丽接单中···",
          stateDetailText: "佳丽正在接单中，请耐心等待哦~",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "待接单佳丽：",
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
          ],
        ),
      },
      OrderItemState.waitingAssign: {
        UserType.agent: OrderDetailWrapper(
          stateText: "等待您接单中···",
          stateDetailText: "接单后，用户才能缴纳费用哦~",
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
          stateText: "待您缴纳保证金服务费···",
          stateDetailText: "保证金在订单结束后会原路返回的哦~",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
          operation: OrderOperationType.payment,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "待用户缴纳保证金服务费···",
          stateDetailText: "双方缴纳的保证金在订单结束后会原路返回哦~",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "待用户缴纳保证金服务费···",
          stateDetailText: "双方缴纳的保证金在订单结束后会原路返回哦~",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
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
          stateText: "待佳丽缴纳保证金···",
          stateDetailText: "Ta缴纳后，约会将正式开始。",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "待您缴纳保证金···",
          stateDetailText: "缴纳后，约会将正式开始。",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
            ),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.requestTime),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.receiveTime),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
          operation: OrderOperationType.payment,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "待佳丽缴纳保证金···",
          stateDetailText: "双方缴纳的保证金在订单结束后会原路返回哦~",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
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
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: isNormal ? "接单佳丽：" : "参与约会：",
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
          bottomTipText: "保证金将在订单完成后原账户退回",
          operation: OrderOperationType.finish,
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "用户缴纳服务费：",
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
              changeTitle: "待收金额：",
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              displayType: OrderDetailDisplayType.agentFee,
              changeTitle: "佳丽服务费：",
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: "待收金额：",
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
      },
      OrderItemState.waitingConfirmForReceive: {
        UserType.user: OrderDetailWrapper(
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          hasCancel: true,
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "用户缴纳服务费：",
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
              changeTitle: "待收金额：",
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
          operation: OrderOperationType.cancelAndFinish,
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "订单进行中···",
          stateDetailText: "订单完成后，保证金将原路退回，服务费将付给佳丽。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              displayType: OrderDetailDisplayType.agentFee,
              changeTitle: "佳丽服务费：",
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: "待收金额：",
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
      },
      OrderItemState.cancelForRequest: () {
        // 目前通过双方是否存在支付时间来判断取消是在哪个阶段取消的
        final isCancelGoingAfter =
            model.requestPayTime != 0 && model.receivePayTime != 0;
        if (isCancelGoingAfter) {
          return {
            UserType.user: OrderDetailWrapper(
              stateText: "订单已取消",
              stateDetailText: "保证金以及服务费已原路退回，请注意查收。",
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: "接单佳丽：",
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
                  changeDetail: "您主动取消订单",
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
                  changeDetail: model.breachAmount.toString(),
                ),
              ],
              bottomTipText: "约会进行中，主动取消订单需扣除${model.proportionBreach}%违约金",
            ),
            UserType.beauty: OrderDetailWrapper(
              stateText: "订单已取消",
              stateDetailText: "保证金已原路退回，请注意查收。",
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.request),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: "接单佳丽：",
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
                  changeDetail: "用户取消订单",
                ),
              ],
              bottomTipText: "对方取消订单，您无需承担违约金，保证金原路退回。",
            ),
            UserType.agent: OrderDetailWrapper(
              stateText: "订单已取消",
              stateDetailText: "保证金以及服务费已原路退回。",
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.request),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: "接单佳丽：",
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
                  changeDetail: "用户取消订单",
                ),
              ],
              bottomTipText: "约会进行中，主动取消订单需扣除${model.proportionBreach}%违约金",
            ),
          };
        }
        return {
          UserType.user: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金以及服务费已原路退回，请注意查收。",
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: "接单佳丽：",
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: "您主动取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
          ),
          UserType.beauty: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金已原路退回，请注意查收。",
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
                changeDetail: "用户取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
          ),
          UserType.agent: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金以及服务费已原路退回。",
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: "接单佳丽：",
              ),
              OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.requestTime),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.cancelTime),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.reason,
                changeDetail: "用户取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
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
              stateText: "订单已取消",
              stateDetailText: "保证金以及服务费已原路退回，请注意查收。",
              upDisplayTypes: [
                OrderDetailItem(
                    model: model, displayType: OrderDetailDisplayType.number),
                OrderDetailItem(
                  model: model,
                  displayType: OrderDetailDisplayType.receive,
                  changeTitle: "接单佳丽：",
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
                  changeDetail: "佳丽主动取消订单",
                ),
              ],
              bottomTipText: "对方取消订单，您无需承担违约金，保证金原路退回。",
            ),
            UserType.beauty: OrderDetailWrapper(
              stateText: "订单已取消",
              stateDetailText: "保证金已原路退回，请注意查收。",
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
                  changeDetail: "您主动取消订单",
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
                  changeDetail: model.breachAmount.toString(),
                ),
              ],
              bottomTipText: "约会进行中，主动取消订单需扣除${model.proportionBreach}%违约金",
            ),
            UserType.agent: OrderDetailWrapper(
                stateText: "订单已取消",
                stateDetailText: "保证金以及服务费已原路退回。",
                upDisplayTypes: [
                  OrderDetailItem(
                      model: model, displayType: OrderDetailDisplayType.number),
                  OrderDetailItem(
                      model: model,
                      displayType: OrderDetailDisplayType.request),
                  OrderDetailItem(
                    model: model,
                    displayType: OrderDetailDisplayType.receive,
                    changeTitle: "接单佳丽：",
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
                    changeDetail: "佳丽取消订单",
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
                    changeTitle: "佳丽实付金额：",
                    changeDetail: model.breachAmount.toString(),
                  ),
                ],
                bottomTipText: "约会进行中，主动取消订单需扣除${model.proportionBreach}%违约金"),
          };
        }
        return {
          UserType.user: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金以及服务费已原路退回，请注意查收。",
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: "接单佳丽：",
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
                changeDetail: "佳丽取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
          ),
          UserType.beauty: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金已原路退回，请注意查收。",
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
                changeDetail: "您主动取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
          ),
          UserType.agent: OrderDetailWrapper(
            stateText: "订单已取消",
            stateDetailText: "保证金以及服务费已原路退回。",
            upDisplayTypes: [
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.number),
              OrderDetailItem(
                  model: model, displayType: OrderDetailDisplayType.request),
              OrderDetailItem(
                model: model,
                displayType: OrderDetailDisplayType.receive,
                changeTitle: "接单佳丽：",
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
                changeDetail: "佳丽取消订单",
              ),
            ],
            bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
          ),
        };
      }(),
      OrderItemState.timeOut: {
        UserType.user: OrderDetailWrapper(
          stateText: "订单已取消",
          stateDetailText: "保证金以及服务费已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeDetail: "等待超时",
            ),
          ],
          bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "订单已取消",
          stateDetailText: "保证金已原路退回，请注意查收。",
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
              changeDetail: "等待超时",
            ),
          ],
          bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "订单已取消",
          stateDetailText: "保证金以及服务费已原路退回。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeDetail: "等待超时",
            ),
          ],
          bottomTipText: "该订单已取消，保证金和服务费均会原路返回",
        ),
      },
      OrderItemState.finish: {
        UserType.user: OrderDetailWrapper(
          stateText: "订单已完成",
          stateDetailText: "保证金已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "保证金退回金额：",
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
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "订单已完成",
          stateDetailText: "保证金已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "用户缴纳服务费：",
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
              changeTitle: "实收金额：",
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "订单已完成",
          stateDetailText: "保证金已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              displayType: OrderDetailDisplayType.agentFee,
              changeTitle: "佳丽服务费：",
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: "实收金额：",
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
      },
      OrderItemState.waitingEvaluation: {
        UserType.user: OrderDetailWrapper(
          stateText: "订单已完成，待评价",
          stateDetailText: "保证金已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "保证金退回金额：",
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
          bottomTipText: "保证金将在订单完成后原账户退回",
        ),
        UserType.beauty: OrderDetailWrapper(
          stateText: "订单已完成，待用户评价",
          stateDetailText: "保证金已原路退回，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              changeTitle: "用户缴纳服务费：",
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
              changeTitle: "实收金额：",
              changeDetail: model.beautyAmount.toString(),
            ),
          ],
        ),
        UserType.agent: OrderDetailWrapper(
          stateText: "订单已完成，待用户评价",
          stateDetailText: "保证金已原路退回佳丽账户，请注意查收。",
          upDisplayTypes: [
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.number),
            OrderDetailItem(
                model: model, displayType: OrderDetailDisplayType.request),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.receive,
              changeTitle: "接单佳丽：",
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
              displayType: OrderDetailDisplayType.agentFee,
              changeTitle: "佳丽服务费：",
            ),
            OrderDetailItem(
              model: model,
              displayType: OrderDetailDisplayType.amount,
              changeTitle: "实收金额：",
              changeDetail: model.brokerAmount.toString(),
            ),
          ],
        ),
      },
    };
  }

  // static Map<OrderItemState, Map<OrderItemUserType, OrderDetailWrapper>>
  //     buildFriendWrapperMap(OrderItemModel model) {
  //   return {
  //     OrderItemState.waitingPaymentForRequest: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.waitingPaymentForReceive: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.waitingConfirmForRequest: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.waitingConfirmForReceive: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.cancelForRequest: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.cancelForReceive: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.timeOut: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //     OrderItemState.finish: {
  //       OrderItemUserType.request: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //       OrderItemUserType.receive: OrderDetailWrapper(
  //         stateText: "",
  //         stateDetailText: "",
  //         upDisplayTypes: [],
  //       ),
  //     },
  //   };
  // }
}
