import 'package:get/get.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

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

    Loading.show();
    final res = await VipApi.openVip(packageId: packageId);
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    _fetchData();
    SS.login.fetchMyInfo();
  }

  void onTapPackages(int index) {
    state.packagesIndex.value = index;
  }

  void onTapSelectProtocol() {
    state.selectProtocol.toggle();
  }

  void onTapProtocol(int type) {
    switch (type) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void _fetchData() async {
    Loading.show();
    final res = await VipApi.getVipIndex();
    Loading.dismiss();

    state.vipModel.value = res.data;
    state.packagesIndex.value = 0;
  }
}
