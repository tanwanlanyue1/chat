import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_my_team_state.dart';

class MineMyTeamController extends GetxController {
  final MineMyTeamState state = MineMyTeamState();

  //分页控制器
  final pagingController = DefaultPagingController<UserModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  void _fetchPage(int page) async {
    final res = await UserApi.getTeamUserList(
      page: page,
      size: pagingController.pageSize,
    );

    final list = res.data ?? [];
    if (res.isSuccess) {
      pagingController.appendPageData(list);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

}
