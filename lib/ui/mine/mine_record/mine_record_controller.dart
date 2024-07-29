import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import '../../../common/network/api/api.dart';
import 'mine_record_state.dart';

class MineRecordController extends GetxController {
  final MineRecordState state = MineRecordState();

  final pagingController = DefaultPagingController<ArchivesInfo>(
    refreshController: RefreshController(),
  );

  void onTapToDetail({ArchivesInfo? info}) {
    Get.toNamed(
      AppRoutes.recordDetailsPage,
      arguments: {"archivesInfo": info?.copyWith()},
    )?.then((value) {
      if (value is! bool) return;
      if (value) pagingController.refreshController.requestRefresh();
    });
  }

  void _fetchPage(int page) async {
    final res = await UserApi.archiveList(
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }
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
