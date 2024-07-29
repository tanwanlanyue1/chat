class PaymentChannelRes {
  PaymentChannelRes({
    required this.id,
    required this.platform,
    required this.payChannel,
  });

  ///渠道ID
  final int id;
  final String platform; // 第三方支付平台
  final String payChannel; // 渠道

  factory PaymentChannelRes.fromJson(Map<String, dynamic> json) {
    return PaymentChannelRes(
      id: json["id"] ?? 0,
      platform: json["platform"] ?? "",
      payChannel: json["payChannel"] ?? "",
    );
  }
}
