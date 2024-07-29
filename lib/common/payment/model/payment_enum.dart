
///支付渠道
enum PaymentChannelType {

  ///支付宝
  alipay,

  ///微信小程序
  wx_lite,

  ///快捷支付
  // fast,

  ///苹果内购
  applePay
}

extension PaymentChannelTypeX on PaymentChannelType {

  ///通过渠道类型解析
  /// - return @nullable
  static PaymentChannelType? valueOf(String value) {
    return PaymentChannelType.values.asNameMap()[value];
  }

  ///渠道名称
  String get label {
    switch (this) {
      case PaymentChannelType.alipay:
        return '支付宝支付';
      case PaymentChannelType.wx_lite:
        return '微信支付';
      case PaymentChannelType.applePay:
        return '苹果支付';
      // case PaymentChannelType.fast:
      //   return '银行卡快捷支付';
    }
  }

  ///渠道图标
  String get icon {
    switch (this) {
      case PaymentChannelType.alipay:
        return 'assets/images/common/ic_alipay.png';
      case PaymentChannelType.wx_lite:
        return 'assets/images/common/ic_wechat.png';
      case PaymentChannelType.applePay:
        return 'assets/images/common/ic_wechat.png';
      // case PaymentChannelType.fast:
      //   return 'images/mine/icon_kuaijiezhifu.png';
    }
  }


}

///支付平台
enum PaymentPlatform {
  ///现在付
  xianzai,

  ///汇付
  huifu,

  ///苹果内购
  apple,
}

extension PaymentPlatformX on PaymentPlatform {

  ///通过平台类型解析
  /// - return @nullable
  static PaymentPlatform? valueOf(String value) {
    return PaymentPlatform.values.asNameMap()[value];
  }

}
