import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/widgets/loading.dart';

import 'my_vip_state.dart';

class MyVipController extends GetxController {
  final MyVipState state = MyVipState();

  @override
  void onInit() async {
    Loading.show();
    final res = await VipApi.getVipIndex();
    Loading.dismiss();

    super.onInit();
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
}
