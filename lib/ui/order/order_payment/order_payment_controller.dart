import 'dart:async';

import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

import 'order_payment_state.dart';

class OrderPaymentController extends GetxController with OrderOperationMixin {
  OrderPaymentController({
    required this.orderId,
    required this.type,
    this.vipPackage,
  });

  final int orderId;
  final OrderPaymentType type;
  final VipPackageModel? vipPackage;
  final OrderPaymentState state = OrderPaymentState();

  Timer? _timer;

  @override
  void onInit() {
    SS.login.fetchMyInfo();
    if (type == OrderPaymentType.dating) {
      _fetchData();
    }
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void onTapPaymentType(int index) {
    state.selectIndex.value = index;
  }

  ///支付金额
  num get paymentAmountRx {
    if (type == OrderPaymentType.dating) {
      final isRequest = state.datingModel.value?.requestId == SS.login.userId;
      final deposit = state.datingModel.value?.deposit ?? 0;
      final serviceCharge = state.datingModel.value?.serviceCharge ?? 0;
      return isRequest ? deposit + serviceCharge : deposit;
    } else {
      final vipPackage = this.vipPackage;
      if (vipPackage != null) {
        return vipPackage.discountPrice > 0
            ? vipPackage.discountPrice
            : vipPackage.price;
      }
      return 0;
    }
  }

  ///确认支付
  void onTapPay() {
    if (type == OrderPaymentType.dating) {
      onTapOrderPayment(orderId);
    } else {
      _openVip();
    }
  }

  ///开通VIP
  void _openVip() async {
    final vipPackage = this.vipPackage;
    if (vipPackage == null) {
      return;
    }
    final password = await PaymentPasswordKeyboard.show();
    if (password == null) {
      return;
    }

    Loading.show();
    final response = await VipApi.openVip(
      packageId: vipPackage.id,
      password: password,
    );
    Loading.dismiss();
    if (response.isSuccess) {
      SS.login.fetchMyInfo();
      EventBus().emit(kEventOpenVip);
      Get.offNamed(
        AppRoutes.orderPaymentResultPage,
        arguments: {
          "vipPackage": vipPackage,
          "isSuccess": true,
          "type": OrderPaymentType.vip,
          "vipOrderNo": response.data,
        },
      );
    } else {
      response.showErrorMessage();
    }
  }

  Future<void> _fetchData() async {
    Loading.show();
    final res = await OrderApi.get(
      orderId: orderId,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    final model = res.data;
    if (model != null) {
      state.datingModel.value = model;

      state.countDown.value = model.countDown;
      if (model.countDown > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (state.countDown <= 0) {
            _timer?.cancel();
            return;
          }
          state.countDown.value = state.countDown.value - 1;
        });
      }
      update();
    }
  }
}
