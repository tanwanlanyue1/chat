import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/ui/wish_pavilion/charm/charm_controller.dart';

import 'put_charm_state.dart';

class PutCharmController extends GetxController {
  final PutCharmState state = PutCharmState();

  final pagingController = DefaultPagingController<CharmRecord>(
    refreshController: RefreshController(),
  );

  void onTapPut() {
    final model = pagingController.itemList?.safeElementAt(state.selectIndex);
    if (model == null) return;

    final c = Get.find<CharmController>();
    c.state.charmRecord.value = model;

    Get.back();
  }

  void onTapItem(int index) {
    final item = pagingController.itemList?.safeElementAt(index);
    if (item == null) return;

    state.selectIndex = index;
    state.charmRecord = item;
    update();
  }

  void _fetchPage(int page) async {
    final res = await CharmApi.getRecordList(
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }

    // 当请求第一页时，默认选中第一个
    if (page == 1) onTapItem(0);
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
