import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_list_state.dart';

class OrderListController extends GetxController {
  final OrderListType type;
  OrderListController(this.type);

  final OrderListState state = OrderListState();

  //分页控制器
  final pagingController = DefaultPagingController<OrderListItem>(
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

  void onTapCancel() {}

  void onTapPayment() {}

  void onTapConnect() {}

  void onTapConfirm() {}

  void onTapAssign() {}

  void onTapFinish() {}

  void onTapEvaluation() {}

  void _fetchPage(int page) async {
    await Future.delayed(500.milliseconds);

    switch (type) {
      case OrderListType.going:
        pagingController.appendPageData([
          OrderListItem(itemType: OrderItemType.waitingConfirm),
          OrderListItem(itemType: OrderItemType.waitingPaymentForUser),
          OrderListItem(itemType: OrderItemType.waitingPaymentForBeauty),
          OrderListItem(itemType: OrderItemType.going),
          OrderListItem(itemType: OrderItemType.waitingAssign),
        ]);
        break;
      case OrderListType.cancel:
        pagingController.appendPageData([
          OrderListItem(itemType: OrderItemType.cancelForUser),
          OrderListItem(itemType: OrderItemType.cancelForBeauty),
          OrderListItem(itemType: OrderItemType.timeOut),
        ]);
        break;
      case OrderListType.finish:
        pagingController.appendPageData([
          OrderListItem(itemType: OrderItemType.finish),
          OrderListItem(itemType: OrderItemType.waitingEvaluation),
        ]);
        break;
    }
  }
}
