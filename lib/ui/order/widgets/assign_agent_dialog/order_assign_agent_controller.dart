import 'package:get/get.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/widgets/loading.dart';

class OrderAssignAgentController extends GetxController {
  OrderAssignAgentController(this.orderId);

  final int orderId;

  final selectIndex = Rxn<int>();

  //分页控制器
  final pagingController = DefaultPagingController<TeamUser>(
    firstPage: 1,
    pageSize: 10,
  );

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

  void onTapSelect(int index) {
    selectIndex.value = index;
  }

  void onTapConfirm() async {
    final index = selectIndex.value;
    if (index == null) {
      Loading.showToast("请选择");
      return;
    }

    final item = pagingController.itemList?.safeElementAt(index);
    if (item == null) {
      Loading.showToast("数据异常");
      return;
    }

    Loading.show();
    final res = await OrderApi.assign(orderId: orderId, receiveId: item.uid!);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    Get.back(result: true);
  }

  void _fetchPage(int page) async {
    final res = await UserApi.getOnlineTeamUserList(
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
