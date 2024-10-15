
///钱包订单信息
class PaymentOrderModel {
  PaymentOrderModel({
    required this.id,
    required this.orderNo,
    required this.uid,
    required this.type,
    required this.amount,
    required this.inputAmount,
    required this.orderStatus,
    required this.remark,
    required this.callbackTime,
    required this.createTime,
    required this.payAmount,
    required this.collectionAddress,
    required this.timeout,
  });

  ///	ID
  final int id;

  ///	订单流水号
  final String orderNo;

  ///	用户ID
  final int uid;

  ///类型 （0=充值钱包、1=开通会员）
  final int type;

  ///订单总金额
  final num amount;

  ///用户输入金额
  final num inputAmount;

  ///	订单状态：0待支付 1已支付 2已超时
  int orderStatus;

  ///	订单备注
  final String remark;

  ///	订单回调时间戳
  final int callbackTime;

  ///	创建时间戳
  final int createTime;

  ///	用户实际支付金额
  final num payAmount;

  ///	收款钱包地址
  final String collectionAddress;

  ///订单失效时间戳(毫秒)
  final int timeout;

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json){
    return PaymentOrderModel(
      id: json["id"] ?? 0,
      orderNo: json["orderNo"] ?? "",
      uid: json["uid"] ?? 0,
      type: json["type"] ?? 0,
      amount: json["amount"] ?? 0,
      inputAmount: json["inputAmount"] ?? 0,
      orderStatus: json["orderStatus"] ?? 0,
      remark: json["remark"] ?? "",
      callbackTime: json["callbackTime"] ?? 0,
      createTime: json["createTime"] ?? 0,
      payAmount: json["payAmount"] ?? 0,
      collectionAddress: json["collectionAddress"] ?? "",
      timeout: json["timeout"] ?? 0,
    );
  }

}
