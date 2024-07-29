
import '../model/payment_enum.dart';
import '../payment_interface.dart';
import 'wechat_mini_program_payment.dart';

///微信 - 现在付
class WechatPayWithXianZai extends WechatMiniProgramPayment {
  WechatPayWithXianZai()
      : super(PaymentMethod(
          channelType: PaymentChannelType.wx_lite,
          platform: PaymentPlatform.xianzai,
        ));
}
