
import '../model/payment_enum.dart';
import '../payment_interface.dart';
import 'wechat_mini_program_payment.dart';

///微信 - 汇付
class WechatPayWithHuiFu extends WechatMiniProgramPayment {
  WechatPayWithHuiFu()
      : super(PaymentMethod(
          channelType: PaymentChannelType.wx_lite,
          platform: PaymentPlatform.huifu,
        ));

}
