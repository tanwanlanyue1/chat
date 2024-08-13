import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/network/api/api.dart';
import 'jia_evaluate_state.dart';

class JiaEvaluateController extends GetxController {
  final JiaEvaluateState state = JiaEvaluateState();

  //分页控制器
  final pagingController = DefaultPagingController<EvaluationItemModel>(
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

  ///获取评价列表
  void fetchPage(int page) async {
    // Loading.show();
    final response = await OrderApi.getEvaluateList(
        page: page,
        type: 2
    );
    // Loading.dismiss();
    if (response.isSuccess) {
      EvaluationListModel? items = response.data;
      if(page == 1){
        state.evaluation = items;
        state.label.value = (state.evaluation?.myTag ?? '').split(',');
      }
      pagingController.appendPageData(items?.list ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

}
