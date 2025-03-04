import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/map/map_page.dart';
import 'package:guanjia/ui/plaza/widgets/filtrate_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import '../dating_hall/dating_hall_controller.dart';
import 'nearby_hall_state.dart';

class NearbyHallController extends GetxController {
  final NearbyHallState state = NearbyHallState();
  final controller = Get.find<RectifyTheWorkplaceController>();
  final pagingController = DefaultPagingController<RecommendModel>.single(
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    String tag = "";
    for(var i = 0; i < controller.state.labelList.length; i++){
      tag += "${controller.state.styleList[controller.state.labelList[i]].id},";
    }
    final response = await UserApi.nearbyUserList(
      location: state.location,
      gender: controller.state.filtrateIndex,
      minAge: controller.state.info?.value.likeAgeMin,
      maxAge: controller.state.info?.value.likeAgeMax,
      style: tag,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.setPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //筛选
  void onTapFiltrate(){
    Get.bottomSheet(
        isScrollControlled: true,
        FiltrateBottomSheet(
          callBack: (){
            Get.back();
            controller.state.filtrateIndex = (controller.state.filtrateIndex ?? -1);
            pagingController.refresh();
          },
        )
    );
  }

  ///设置地址
  void setLocation() async {
    PlaceModel? data = await MapPage.go(title: S.current.selectLocation);
    if(data != null){
      state.location = '${data.geometry?.location?.lng},${data.geometry?.location?.lat}';
      pagingController.refresh();
    }
    pagingController.refresh();
  }
}
