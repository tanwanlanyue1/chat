import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_fans_state.dart';

class MineFansController extends GetxController {
  final MineFansState state = MineFansState();

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
      type: 1,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }
  }
  /// 查询粉丝，关闭红点
  ///type: 0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注，6系统公告，7评论消息(3和4)
  void getMessageList() async {
    UserApi.getMessageList(type: 5, size: 1);
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    getMessageList();
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();

    super.onClose();
  }
}
