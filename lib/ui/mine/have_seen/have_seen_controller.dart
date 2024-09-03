import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'have_seen_state.dart';

class HaveSeenController extends GetxController {
  final HaveSeenState state = HaveSeenState();

  //分页控制器
  final pagingController = DefaultPagingController<VisitList>(
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

  ///谁看过我
  void fetchPage(int page) async {
    Loading.show();
    final response = await UserApi.getVisitList(
        page: page
    );
    Loading.dismiss();
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
      update(['bottomLength']);
      SS.appConfig.configRx.update((val) {
        val?.lookMessage = false;
      });
    } else {
      pagingController.error = response.errorMessage;
    }
  }

}
