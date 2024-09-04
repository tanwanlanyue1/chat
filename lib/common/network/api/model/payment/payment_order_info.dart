class PaymentOrderInfoModel {
  PaymentOrderInfoModel({
    required this.id,
    required this.orderNo,
    required this.uid,
    required this.skuId,
    required this.goldNum,
    required this.type,
    required this.giftGoldNum,
    required this.amount,
    required this.payChannel,
    required this.payPlatform,
    required this.outTradeNo,
    required this.orderStatus,
    required this.remark,
    required this.payTime,
    required this.callbackTime,
    required this.createTime,
  });

  final int id; // ID
  final String orderNo; // 订单流水号
  final int uid; // 用户ID
  final String skuId; // 挡位id
  final int goldNum; // 订单金币数量
  final int type; // 类型 （0=充值、1=开通会员）
  final int giftGoldNum; // 订单活动赠送金币数量
  final num amount; // 订单总金额
  final String payChannel; // 支付渠道
  final String payPlatform; // 第三方支付平台
  final String outTradeNo; // 第三方支付流水号
  final int orderStatus; // 订单状态：0未付款 1已付款 2已退款
  final String remark; // 订单备注
  final int payTime; // 支付时间
  final int callbackTime; // 订单回调时间
  final int createTime; // 创建时间

  factory PaymentOrderInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderInfoModel(
      id: json["id"] ?? 0,
      orderNo: json["orderNo"] ?? "",
      uid: json["uid"] ?? 0,
      skuId: json["skuId"] ?? "",
      goldNum: json["goldNum"] ?? 0,
      type: json["type"] ?? 0,
      giftGoldNum: json["giftGoldNum"] ?? 0,
      amount: json["amount"] ?? 0,
      payChannel: json["payChannel"] ?? "",
      payPlatform: json["payPlatform"] ?? "",
      outTradeNo: json["outTradeNo"] ?? "",
      orderStatus: json["orderStatus"] ?? 0,
      remark: json["remark"] ?? "",
      payTime: json["payTime"] ?? 0,
      callbackTime: json["callbackTime"] ?? 0,
      createTime: json["createTime"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderNo": orderNo,
        "uid": uid,
        "skuId": skuId,
        "goldNum": goldNum,
        "type": type,
        "giftGoldNum": giftGoldNum,
        "amount": amount,
        "payChannel": payChannel,
        "payPlatform": payPlatform,
        "outTradeNo": outTradeNo,
        "orderStatus": orderStatus,
        "remark": remark,
        "payTime": payTime,
        "callbackTime": callbackTime,
        "createTime": createTime,
      };
}
