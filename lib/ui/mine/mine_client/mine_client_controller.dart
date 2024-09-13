import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_client_state.dart';

class MineClientController extends GetxController {
  final MineClientState state = MineClientState();

  //分页控制器
  final pagingController = DefaultPagingController<UserModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    // TODO: implement onInit
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  ///获取佳丽的客户列表
  void fetchPage(int page) async {
    final response = await OrderApi.getMyClientList(
        page: page
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
      update(['bottomLength']);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}
