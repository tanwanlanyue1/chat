import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/payment/payment_manager.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../network/api/payment_api.dart';
import 'model/payment_enum.dart';
import 'payment_interface.dart';

///支付功能mixin
mixin PaymentMixin on DisposableInterface, GetAutoDisposeMixin {
  final _paymentManager = PaymentManager();
  final paymentState = PaymentState();

  @override
  void onInit() {
    super.onInit();
    fetchChannelData();
  }

  ///获取支付渠道数据
  Future<void> fetchChannelData() async{
    final response = await PaymentApi.channelList(Platform.isAndroid ? 0 : 1);
    final channelList = <PaymentMethod>[];
    if (response.isSuccess) {
      response.data?.forEach((element) {
        final channelType = PaymentChannelTypeX.valueOf(element.payChannel);
        final platform = PaymentPlatformX.valueOf(element.platform);
        if (channelType != null && platform != null) {
          channelList.add(PaymentMethod(channelType: channelType, platform: platform, id: element.id));
        }
      });
    }
    paymentState.paymentChannelListRx.value = channelList;
    //默认选中
    paymentState.selectedChannelTypeRx.value ??= paymentState.paymentChannelListRx.firstOrNull?.channelType;
  }

  ///发起支付
  ///- paymentMethod 支付方式
  ///- order 订单信息
  Future<PayResult<T>> doPay<T extends TradeOrder>({
    required PaymentMethod paymentMethod,
    required T order,
  }) async {
    final paymentInterface = _paymentManager.getPaymentInterface(paymentMethod);
    if (paymentInterface == null) {
      Loading.showToast('不支持的支付方式');
      return PayResult.failed(order);
    }
    return paymentInterface.pay(order);
  }

  @override
  void onClose() {
    _paymentManager.dispose();
    super.onClose();
  }
}



class PaymentState {

  ///支付方式列表
  final paymentChannelListRx = <PaymentMethod>[].obs;

  ///当前选中的支付方式
  final selectedChannelTypeRx = Rxn<PaymentChannelType>();

  ///当前选中的支付方式
  PaymentMethod? get selectedChannelRx => paymentChannelListRx.firstWhereOrNull((element) => element.channelType == selectedChannelTypeRx.value);

  ///订单金额
  final orderAmountRx = 0.0.obs;

  ///应付金额(使用各种优惠券后的最终价格)
  final payableAmountRx = 0.0.obs;

  ///是否已选中隐私政策
  final isCheckedPrivacyPolicyRx = true.obs;

}
