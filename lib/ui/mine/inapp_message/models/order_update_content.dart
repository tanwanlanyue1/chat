

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

  OrderUpdateContent({
    required this.orderId,
    required this.requestId,
    required this.receiveId,
    required this.introducerId,
  });

  factory OrderUpdateContent.fromJson(Map<String, dynamic> json) {

    return OrderUpdateContent(
      orderId: json['orderId'] ?? 0,
      requestId: json['requestId'] ?? 0,
      receiveId: json['receiveId'] ?? 0,
      introducerId: json['introducerId'],
    );
  }
}
