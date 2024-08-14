import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/ui/plaza/widgets/filtrate_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dating_hall_state.dart';

class RectifyTheWorkplaceController extends GetxController {
  final RectifyTheWorkplaceState state = RectifyTheWorkplaceState();

  final pagingController = DefaultPagingController<RecommendModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  //筛选
  void onTapFiltrate(){
    Get.bottomSheet(
      isScrollControlled: true,
        FiltrateBottomSheet()
    );
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    final response = await UserApi.recommendList(
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

}
