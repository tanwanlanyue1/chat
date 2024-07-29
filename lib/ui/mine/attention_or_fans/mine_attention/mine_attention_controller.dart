import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_attention_state.dart';

class MineAttentionController extends GetxController {
  final MineAttentionState state = MineAttentionState();

  final pagingController = DefaultPagingController<UserModel>(
    refreshController: RefreshController(),
  );

  void onTapItem(int uid) {
    Get.toNamed(
      AppRoutes.userCenterPage,
      arguments: {
        "userId": uid,
      },
    );
  }

  void fetchAttention(int index) async {
    final model = pagingController.itemList?.safeElementAt(index);

    if (model == null) return;

    Loading.show();
    final res = await UserApi.attention(uid: model.uid);
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    switch (res.data) {
      case 0:
        model.mutualFollow = UserAttentionStatus.following;
        break;
      case 1:
        model.mutualFollow = UserAttentionStatus.notFollowing;
        break;

      default:
        model.mutualFollow = UserAttentionStatus.unknown;
        break;
    }

    update();
  }

  void _fetchPage(int page) async {
    final res = await UserApi.attentionOrFansList(
      type: 0,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);

    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();

    super.onClose();
  }
}
