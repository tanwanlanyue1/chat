import 'package:get/get.dart';

import '../../../common/routes/app_pages.dart';
import 'mine_reward_points_state.dart';

class MineRewardPointsController extends GetxController {
  final MineRewardPointsState state = MineRewardPointsState();

  void onTapRewardPointsDetail() {
    Get.toNamed(AppRoutes.mineRewardPointsDetail);
  }

}
