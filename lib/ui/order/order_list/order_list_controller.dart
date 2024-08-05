import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_state.dart';

class OrderListController extends GetxController {
  final OrderListType type;
  OrderListController(this.type);

  final OrderListState state = OrderListState();

  //分页控制器
  final pagingController = DefaultPagingController<int>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    print(type);
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  void onTapItem() {
    Get.toNamed(AppRoutes.orderDetailPage);
  }

  void _fetchPage(int page) async {
    if (page > 2) {
      pagingController.appendPageData([]);
      return;
    }

    await Future.delayed(500.milliseconds);
    pagingController.appendPageData(
        List.generate(10, (index) => index + pagingController.length));
  }
}
