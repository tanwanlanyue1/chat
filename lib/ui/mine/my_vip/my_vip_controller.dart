import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

import 'my_vip_state.dart';

class MyVipController extends GetxController with GetAutoDisposeMixin {
  final MyVipState state = MyVipState();

  @override
  void onInit() {
    _fetchData();
    //监听vip开通成功
    autoDisposeWorker(EventBus().listen(kEventOpenVip, (data) {
      _fetchData(isVisibleLoading: false);
    }));
    super.onInit();
  }

  void onTapOpen() async {
    final packages = state.vipModel.value?.packages ?? [];
    if (packages.isEmpty) return;

    final package = packages.safeElementAt(state.packagesIndex.value);
    if (package == null) return;

    if (state.selectProtocol.isFalse) {
      Loading.showToast(S.current.checkVipAgreement);
      return;
    }

    Get.toNamed(AppRoutes.orderPaymentPage, arguments: {
      "type": OrderPaymentType.vip,
      "vipPackage": package,
    });
  }

  void onTapPackages(int index) {
    state.packagesIndex.value = index;
  }

  void onTapSelectProtocol() {
    state.selectProtocol.toggle();
  }

  void _fetchData({bool isVisibleLoading = true}) async {
    if(isVisibleLoading){
      Loading.show();
    }
    final res = await VipApi.getVipIndex();
    if(isVisibleLoading){
      Loading.dismiss();
    }

    state.vipModel.value = res.data;
    state.packagesIndex.value = 0;
  }
}
