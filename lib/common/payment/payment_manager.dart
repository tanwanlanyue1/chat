import 'impl/alipay_with_huifu.dart';
import 'impl/alipay_with_xianzai.dart';
import 'impl/wechat_pay_with_huifu.dart';
import 'impl/wechat_pay_with_xianzai.dart';
import 'payment_interface.dart';

///支付接口管理
class PaymentManager {
  final _paymentInterfaces = <PaymentMethod, PaymentInterface>{};

  PaymentManager(){

    //微信 - 现在付
    register(WechatPayWithXianZai());

    //微信 - 汇付
    register(WechatPayWithHuiFu());

    //支付宝 - 现在付
    register(AlipayWithXianZai());

    //支付宝 - 汇付
    register(AlipayWithHuiFu());

  }

  ///注册支付接口
  void register(PaymentInterface paymentInterface) {
    _paymentInterfaces[paymentInterface.paymentMethod] = paymentInterface;
  }

  ///获取支付接口
  ///- return @nullable
  PaymentInterface? getPaymentInterface(PaymentMethod paymentMethod){
    return _paymentInterfaces[paymentMethod];
  }

  ///清理资源
  void dispose(){
    _paymentInterfaces.forEach((key, value) {
      value.dispose();
    });
    _paymentInterfaces.clear();
  }
}
