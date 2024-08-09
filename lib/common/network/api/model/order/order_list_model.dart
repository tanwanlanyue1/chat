import 'package:guanjia/common/network/api/model/user/user_model.dart';

enum OrderType {
  normal(1), // 普通订单
  friend(2); // 征友订单

  final int type;

  const OrderType(this.type);

  static final _typeToOrderMap = Map<int, OrderType>.fromIterable(
    OrderType.values,
    key: (e) => e.type,
  );

  static OrderType valueForType(int type) {
    return _typeToOrderMap[type] ?? OrderType.normal;
  }

  bool get isNormal => this == OrderType.normal;
  bool get isFriend => this == OrderType.friend;
}

enum OrderState {
  waitingAcceptance, // 待接受
  waitingPayment, // 已接受(待双方缴费)
  going, // 进行中
  finish, // 完成
  cancel; // 取消

  static OrderState valueForIndex(int index) {
    return OrderState.values.elementAtOrNull(index) ?? OrderState.finish;
  }
}

enum OrderUserState {
  waitingPayment, // 待支付
  payment, // 已支付
  confirm, // 已确认
  cancel; // 已取消

  static OrderUserState valueForIndex(int index) {
    return OrderUserState.values.elementAtOrNull(index) ??
        OrderUserState.confirm;
  }

  bool get isWaitingPayment => this == OrderUserState.waitingPayment;
  bool get isPayment => this == OrderUserState.payment;
  bool get isConfirm => this == OrderUserState.confirm;
  bool get isCancel => this == OrderUserState.cancel;
}

class OrderListModel {
  OrderListModel({
    required this.list,
    required this.userInfo,
    required this.waitTimeCount,
    required this.otherCancelCount,
    required this.selfCancelCount,
    required this.evaluateCount,
    required this.completeCount,
    required this.allCompleteCount,
  });

  final List<OrderItemModel> list; // 订单列表
  final UserModel? userInfo; // 订单用户
  final int waitTimeCount; // 等待超时
  final int otherCancelCount; // 对方取消
  final int selfCancelCount; // 主动取消
  final int evaluateCount; // 已完成待评价
  final int completeCount; // 已完成已评价
  final int allCompleteCount; // 已完成

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    return OrderListModel(
      list: json["list"] == null
          ? []
          : List<OrderItemModel>.from(
              json["list"]!.map((x) => OrderItemModel.fromJson(x))),
      userInfo: json["userInfo"] == null
          ? null
          : UserModel.fromJson(json["userInfo"]),
      waitTimeCount: json["waitTimeCount"] ?? 0,
      otherCancelCount: json["otherCancelCount"] ?? 0,
      selfCancelCount: json["selfCancelCount"] ?? 0,
      evaluateCount: json["evaluateCount"] ?? 0,
      completeCount: json["completeCount"] ?? 0,
      allCompleteCount: json["allCompleteCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "list": list.map((x) => x?.toJson()).toList(),
        "userInfo": userInfo?.toJson(),
        "waitTimeCount": waitTimeCount,
        "otherCancelCount": otherCancelCount,
        "selfCancelCount": selfCancelCount,
        "evaluateCount": evaluateCount,
        "completeCount": completeCount,
        "allCompleteCount": allCompleteCount,
      };
}

class OrderItemModel {
  OrderItemModel({
    required this.id,
    required this.number,
    required this.type,
    required this.state,
    required this.requestState,
    required this.requestId,
    required this.requestName,
    required this.requestAvatar,
    required this.receiveState,
    required this.receiveId,
    required this.receiveName,
    required this.receiveAvatar,
    required this.introducerId,
    required this.introducerName,
    required this.introducerAvatar,
    required this.deposit,
    required this.serviceCharge,
    required this.proportionBreach,
    required this.breachAmount,
    required this.proportionPlatform,
    required this.platformAmount,
    required this.proportionBroker,
    required this.brokerAmount,
    required this.proportionBeauty,
    required this.beautyAmount,
    required this.remark,
    required this.createTime,
    required this.receiveTime,
    required this.requestPayTime,
    required this.receivePayTime,
    required this.switchTime,
    required this.cancelTime,
    required this.completeTime,
    required this.evaluateTag,
    required this.evaluateContent,
    required this.evaluateScore,
  });

  final int id; // 订单id
  final String number; // 订单编号
  final OrderType type; // 订单类型 1普通订单 2征友约会
  final OrderState state; // 订单状态 0待接约 1已接约(待双方缴费) 2进行中 3已完成 4已取消
  final OrderUserState requestState; // 下单用户状态 0待支付 1已支付 2已确认 3已取消
  final int requestId; // 下单用户id
  final String requestName; // 下单用户姓名
  final String requestAvatar; // 下单用户头像
  final OrderUserState receiveState; // 接单人状态 0待支付 1已支付 2已确认 3已取消
  final int receiveId; // 接单人id
  final String receiveName; // 接单人姓名
  final String receiveAvatar; // 接单人头像
  final int introducerId; // 经纪人id
  final String introducerName; // 经纪人姓名
  final String introducerAvatar; // 经纪人头像
  final num deposit; // 保证金
  final num serviceCharge; // 服务费
  final num proportionBreach; // 违约金比例%
  final num breachAmount; // 违约金
  final num proportionPlatform; // 平台收取比例%
  final num platformAmount; // 平台费
  final num proportionBroker; // 经纪人收取比例%
  final num brokerAmount; // 经纪人介绍费
  final num proportionBeauty; // 佳丽收取比例%
  final num beautyAmount; // 佳丽实收金额
  final String remark; // 备注
  final String createTime; // 创建时间
  final String receiveTime; // 佳丽接单时间
  final String requestPayTime; // 下单用户支付时间
  final String receivePayTime; // 接单人支付时间
  final String switchTime; // 经纪人转派给佳丽时间
  final String cancelTime; // 取消时间
  final String completeTime; // 订单完成时间
  final String evaluateTag; // 评价标签
  final String evaluateContent; // 评价内容
  final int evaluateScore; // 评级星级

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"] ?? 0,
      number: json["number"] ?? "",
      type: OrderType.valueForType(json["type"] ?? 1),
      state: OrderState.valueForIndex(json["state"] ?? 0),
      requestState: OrderUserState.valueForIndex(json["requestState"] ?? 0),
      requestId: json["requestId"] ?? 0,
      requestName: json["requestName"] ?? "",
      requestAvatar: json["requestAvatar"] ?? "",
      receiveState: OrderUserState.valueForIndex(json["receiveState"] ?? 0),
      receiveId: json["receiveId"] ?? 0,
      receiveName: json["receiveName"] ?? "",
      receiveAvatar: json["receiveAvatar"] ?? "",
      introducerId: json["introducerId"] ?? 0,
      introducerName: json["introducerName"] ?? "",
      introducerAvatar: json["introducerAvatar"] ?? "",
      deposit: json["deposit"] ?? 0,
      serviceCharge: json["serviceCharge"] ?? 0,
      proportionBreach: json["proportionBreach"] ?? 0,
      breachAmount: json["breachAmount"] ?? 0,
      proportionPlatform: json["proportionPlatform"] ?? 0,
      platformAmount: json["platformAmount"] ?? 0,
      proportionBroker: json["proportionBroker"] ?? 0,
      brokerAmount: json["brokerAmount"] ?? 0,
      proportionBeauty: json["proportionBeauty"] ?? 0,
      beautyAmount: json["beautyAmount"] ?? 0,
      remark: json["remark"] ?? "",
      createTime: json["createTime"] ?? "",
      receiveTime: json["receiveTime"] ?? "",
      requestPayTime: json["requestPayTime"] ?? "",
      receivePayTime: json["receivePayTime"] ?? "",
      switchTime: json["switchTime"] ?? "",
      cancelTime: json["cancelTime"] ?? "",
      completeTime: json["completeTime"] ?? "",
      evaluateTag: json["evaluateTag"] ?? "",
      evaluateContent: json["evaluateContent"] ?? "",
      evaluateScore: json["evaluateScore"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "type": type.type,
        "state": state.index,
        "requestState": requestState.index,
        "requestId": requestId,
        "requestName": requestName,
        "requestAvatar": requestAvatar,
        "receiveState": receiveState.index,
        "receiveId": receiveId,
        "receiveName": receiveName,
        "receiveAvatar": receiveAvatar,
        "introducerId": introducerId,
        "introducerName": introducerName,
        "introducerAvatar": introducerAvatar,
        "deposit": deposit,
        "serviceCharge": serviceCharge,
        "proportionBreach": proportionBreach,
        "breachAmount": breachAmount,
        "proportionPlatform": proportionPlatform,
        "platformAmount": platformAmount,
        "proportionBroker": proportionBroker,
        "brokerAmount": brokerAmount,
        "proportionBeauty": proportionBeauty,
        "beautyAmount": beautyAmount,
        "remark": remark,
        "createTime": createTime,
        "receiveTime": receiveTime,
        "requestPayTime": requestPayTime,
        "receivePayTime": receivePayTime,
        "switchTime": switchTime,
        "cancelTime": cancelTime,
        "completeTime": completeTime,
        "evaluateTag": evaluateTag,
        "evaluateContent": evaluateContent,
        "evaluateScore": evaluateScore,
      };
}
