import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'nearby_hall_state.dart';

class NearbyHallController extends GetxController {
  final NearbyHallState state = NearbyHallState();

  final pagingController = DefaultPagingController<int>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  void fetchPage(int page) async {
    await Future.delayed(500.milliseconds);
    pagingController.appendPageData(
        List.generate(10, (index) => index + pagingController.length));
  }

}
