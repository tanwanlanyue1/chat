import 'dart:convert';

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
    pageSize: 20,
    refreshController: RefreshController(),
  );

  //筛选
  void onTapFiltrate(){
    Get.bottomSheet(
      isScrollControlled: true,
        FiltrateBottomSheet(
          callBack: (){
            Get.back();
            pagingController.refresh();
          },
        )
    );
  }

  //设置标签
  void setLabel(int index){
    if(state.labelListSelect.contains(index)){
      state.labelListSelect.remove(index);
    }else{
      state.labelListSelect.add(index);
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
    state.filtrateIndex = state.info?.value.likeSex.index;
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }


  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if(state.first){
      List <int> userLike = (state.info?.value.likeStyle != null && state.info?.value.likeStyle?.length != 0) ?
      ((state.info?.value.likeStyle?.split(','))?.map(int.parse).toList() ?? []):[];
      await additionLabel();

      for(var i = 0; i < state.styleList.length;i++){
        if(userLike.contains(state.styleList[i].id)){
          state.labelList.add(i);
          state.labelListDefault.add(i);
          state.labelListSelect.add(i);
        }
      }
      state.first = false;
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
      size: pagingController.pageSize
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //附加标签
  Future<List<LabelModel>?> additionLabel({int? index}) async {
    final response = await OpenApi.getStyleList(
      type: index ?? (state.filtrateIndex != null ? (state.filtrateIndex == -1 ? 0 : state.filtrateIndex!) : 0),
    );
    if (response.isSuccess) {
      if(index != null){
        state.styleListSelect = response.data ?? [];
      }else{
        state.styleListDefault = response.data ?? [];
        state.styleListSelect = response.data ?? [];
        state.styleList = response.data ?? [];
      }
      state.labelListSelect.clear();
      update(['bottomSheet']);
    }else{
      response.showErrorMessage();
    }
  }

}
