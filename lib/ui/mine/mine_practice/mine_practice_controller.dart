import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_practice_state.dart';

class MinePracticeController extends GetxController {
  final MinePracticeState state = MinePracticeState();

  final loginService = SS.login;

  void onTapRanking() {
    Get.toNamed(
      AppRoutes.meritListPage,
      arguments: {"initialIndex": 1},
    );
  }

  @override
  void onInit() async {
    loginService.fetchLevelMoneyInfo();

    Loading.show();
    final res = await UserApi.getLevelList(type: 1);
    Loading.dismiss();

    if (res.isSuccess && res.data != null) {
      state.levelResList.value = res.data!;
    }

    super.onInit();
  }
}
