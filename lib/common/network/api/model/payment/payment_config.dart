class PaymentConfigRes {
  PaymentConfigRes({
    required this.id,
    required this.type,
    required this.goldNum,
    required this.price,
    required this.firstPrice,
    required this.gift,
    required this.productId,
    required this.skuId,
    required this.isFirst,
  });

  /// ID
  final int id;

  ///	平台类型 （0=安卓 1=ios）
  final int type;

  /// 境修币数量
  final int goldNum;

  /// 价格
  final num price;

  /// 首次充值价格
  final num firstPrice;

  /// 赠送境修币
  final int gift;

  ///挡位id(不同平台的挡位id需保持一致)
  final String skuId;

  ///是否首次充值 0否 1是
  final int isFirst;

  ///=======iOS专用字段===========

  /// 苹果内购产品ID
  final String productId;

  factory PaymentConfigRes.fromJson(Map<String, dynamic> json) {
    return PaymentConfigRes(
      id: json["id"] ?? 0,
      type: json["type"] ?? 0,
      goldNum: json["goldNum"] ?? 0,
      price: json["price"] ?? 0,
      firstPrice: json["firstPrice"] ?? 0,
      gift: json["gift"] ?? 0,
      skuId: json["skuId"] ?? '',
      isFirst: json["isFirst"] ?? 0,
      productId: json["productId"] ?? '',
    );
  }
}
