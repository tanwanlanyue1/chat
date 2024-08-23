import 'package:guanjia/common/network/api/model/order/order_list_model.dart';

///订单变更 应用内消息内容
class OrderUpdateContent {
  ///订单ID
  final int orderId;

  ///订单发起人
  final int requestId;

  ///订单接收人
  final int receiveId;

  ///订单经纪人
  final int? introducerId;

  ///订单状态 0待接约 1已接约(待双方缴费) 2进行中 3已完成 4已取消 5超时
  final OrderStatus state;

  OrderUpdateContent({
    required this.orderId,
    required this.requestId,
    required this.receiveId,
    required this.introducerId,
    required this.state,
  });

  factory OrderUpdateContent.fromJson(Map<String, dynamic> json) {
    return OrderUpdateContent(
      orderId: json['orderId'] ?? 0,
      requestId: json['requestId'] ?? 0,
      receiveId: json['receiveId'] ?? 0,
      introducerId: json['introducerId'],
      state: OrderStatus.valueForIndex(json["state"] ?? 0),
    );
  }
}
