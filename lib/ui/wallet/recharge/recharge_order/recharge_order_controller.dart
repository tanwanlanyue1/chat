import 'dart:async';

import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'recharge_order_state.dart';

class RechargeOrderController extends GetxController {
  final RechargeOrderState state = RechargeOrderState();

  ///订单流水号
  final String orderNo;

  ///来自充值页面跳转
  final bool fromRechargePage;

  ///跳转过来时，订单是否还未结束
  final bool _isPending;

  Timer? _timer;

  ///轮询时隔
  static const kPollingDuration = Duration(seconds: 5);

  RechargeOrderController({
    required this.orderNo,
    this.fromRechargePage = false,
    bool isPending = true,
  }): _isPending = isPending;

  @override
  void onInit() {
    super.onInit();
    fetchData().then((value) => _pollingFetchData());

    //如果提示文本为空，刷新提示文本
    if (state.descRx.isEmpty) {
      SS.appConfig.fetchData();
    }
  }

  Future<void> fetchData({bool isLoadingVisible = true}) async {
    if (isLoadingVisible) {
      Loading.show();
    }
    final response = await PaymentApi.getOrderInfo(orderNo);
    if (isLoadingVisible) {
      Loading.dismiss();
    }
    if (response.isSuccess) {
      state.orderRx.value = response.data;
      if(_isPending && state.orderStatusRx?.isSuccess == true){
        EventBus().emit(kEventRechargeSuccess, orderNo);
      }
    } else {
      if (isLoadingVisible) {
        response.showErrorMessage();
      }
    }
  }

  ///轮询订单状态
  void _pollingFetchData() {
    //待支付 才需要轮询
    if (state.orderStatusRx?.isPending != true || isClosed) {
      return;
    }

    _timer?.cancel();
    _timer = Timer(kPollingDuration, () async {
      if (!isClosed) {
        await fetchData(isLoadingVisible: false);
        if (state.orderStatusRx?.isSuccess == true) {
          //到账，刷新余额
          SS.login.fetchMyInfo();
        } else {
          _pollingFetchData();
        }
      }
    });
  }

  ///超时
  void onExpired() {
    state.orderRx.update((val) {
      val?.orderStatus = 2;
    });
  }

  ///完成转账
  void onTapComplete() async {
    await fetchData();
    if (state.orderStatusRx?.isPending == true) {
      Loading.showToast(S.current.rechargeHint);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
