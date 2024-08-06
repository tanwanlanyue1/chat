import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';

import 'friend_date_state.dart';

class FriendDateController extends GetxController {
  final FriendDateState state = FriendDateState();

  //发布邀约
  void onTapInvitation() {
    Get.toNamed(AppRoutes.releaseInvitation);
  }

  //选择更多
  Future<void> selectMore() async {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: ["1V1私聊发布者", "删除(个人发布者)", "举报/投诉"],
        onTap: (index) async {},
      ),
    );
  }

}
