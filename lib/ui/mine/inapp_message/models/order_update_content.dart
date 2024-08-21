

///订单变更 应用内消息内容
class OrderUpdateContent {

  ///订单ID
  final int orderId;


  OrderUpdateContent({
    required this.orderId,
  });

  factory OrderUpdateContent.fromJson(Map<String, dynamic> json) {

    return OrderUpdateContent(
      orderId: json['orderId'] ?? 0,
    );
  }
}
