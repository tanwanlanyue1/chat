
class InAppPurchaseOrder {

  ///业务后台定义的唯一ID
  final int id;

  ///后台订单ID
  final String orderNo;

  ///苹果产品ID
  final String productId;

  ///创建时间
  final int createTimeMs;

  InAppPurchaseOrder({
    required this.id,
    required this.orderNo,
    required this.productId,
    required this.createTimeMs,
  });


  static InAppPurchaseOrder? fromJson(Map<String, dynamic> json) {
    return InAppPurchaseOrder(
      id: json['id'] ?? 0,
      orderNo: json['orderNo'] ?? '',
      productId: json['productId'] ?? '',
      createTimeMs: json['createTimeMs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNo': orderNo,
      'productId': productId,
      'createTimeMs': createTimeMs,
    };
  }

}
