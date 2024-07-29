import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'all_sutras_state.dart';

class AllSutrasController extends GetxController {
  final AllSutrasState state = AllSutrasState();

  late final pagingController = DefaultPagingController<BuddhistSutrasModel>(
    firstPage: 1,
    pageSize: 30,
    refreshController: RefreshController(),
  )..addPageRequestListener(_fetchPage);

  void _fetchPage(int page) async {
    final response = await WishPavilionApi.getBuddhistSutrasList(
      type: 0,
      page: page,
      size: pagingController.pageSize,
      isAudio: 1
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}
