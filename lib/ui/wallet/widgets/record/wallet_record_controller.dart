import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/widgets/loading.dart';

class WalletRecordController extends GetxController {
  // 分页控制器
  final DefaultPagingController pagingController =
      DefaultPagingController<PurseLogList>();

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

  void _fetchPage(int page) async {
    Loading.show();
    final res = await UserApi.getPurseLogList(logType: -1);
    Loading.dismiss();

    if (res.isSuccess) {
      final listSubModel = res.data ?? [];
      pagingController.appendPageData(listSubModel);
    } else {
      pagingController.error = res.errorMessage;
    }
  }
}
