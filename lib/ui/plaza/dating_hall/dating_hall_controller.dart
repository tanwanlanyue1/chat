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
        FiltrateBottomSheet(
          callBack: (){
            Get.back();
            pagingController.onRefresh();
          },
        )
    );
  }

  //设置标签
  void setLabel(int index){
    if(state.labelList.contains(index)){
      state.labelList.remove(index);
    }else{
      state.labelList.add(index);
    }
    update(['bottomSheet']);
  }

  //年龄筛选
  void onChangeLikeAge(int likeAgeMin, int likeAgeMax) {
    state.info?.update((val) {
      val?.likeAgeMin = likeAgeMin;
      val?.likeAgeMax = likeAgeMax;
    });
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    additionLabel();
    super.onInit();
  }

  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    String tag = "";
    for(var i = 0; i < state.labelList.length; i++){
      tag += "${state.styleList[state.labelList[i]].id},";
    }
    final response = await UserApi.recommendList(
      gender: state.filtrateIndex,
      minAge: state.info?.value.likeAgeMin,
      maxAge: state.info?.value.likeAgeMax,
      style: tag,
      page: page,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //附加标签
  void additionLabel() async {
    final response = await OpenApi.getStyleList(
      type: state.filtrateIndex,
    );
    if (response.isSuccess) {
      state.styleList = response.data ?? [];
      state.labelList.clear();
      update(['bottomSheet']);
    }else{
      response.showErrorMessage();
    }
  }

}
