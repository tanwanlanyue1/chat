import 'package:get/get.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

import 'my_vip_state.dart';

class MyVipController extends GetxController {
  final MyVipState state = MyVipState();

  @override
  void onInit() {
    _fetchData();

    super.onInit();
  }

  void onTapOpen() async {
    final packages = state.vipModel.value?.packages ?? [];
    if (packages.isEmpty) return;

    final packageId = packages.safeElementAt(state.packagesIndex.value)?.id;
    if (packageId == null) return;

    if(state.selectProtocol.isFalse){
      Loading.showToast('请先勾选确认会员服务协议');
      return;
    }

    final password = await PaymentPasswordKeyboard.show();
    if(password == null){
      return;
    }

    Loading.show();
    final response = await VipApi.openVip(packageId: packageId, password: password);
    Loading.dismiss();
    if(response.isSuccess){
      Loading.showToast('开通成功');
      _fetchData();
      SS.login.fetchMyInfo();
    }else{
      response.showErrorMessage();
    }
  }

  void onTapPackages(int index) {
    state.packagesIndex.value = index;
  }

  void onTapSelectProtocol() {
    state.selectProtocol.toggle();
  }

  void _fetchData() async {
    Loading.show();
    final res = await VipApi.getVipIndex();
    Loading.dismiss();

    state.vipModel.value = res.data;
    state.packagesIndex.value = 0;
  }
}
