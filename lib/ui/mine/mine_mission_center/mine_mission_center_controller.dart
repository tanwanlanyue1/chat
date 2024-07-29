import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'mine_mission_center_state.dart';

class MineMissionCenterController extends GetxController {
  final MineMissionCenterState state = MineMissionCenterState();

  void onTapRewardPoints() {
    Get.toNamed(AppRoutes.mineRewardPoints);
  }
}
