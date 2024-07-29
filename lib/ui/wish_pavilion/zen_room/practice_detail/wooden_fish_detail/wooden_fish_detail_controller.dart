import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/WoodenFishRecordModel.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'wooden_fish_detail_state.dart';

class WoodenFishDetailController extends GetxController {
  final WoodenFishDetailState state = WoodenFishDetailState();

  late final pagingController =
  DefaultPagingController<WoodenFishRecordItem>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRecitationCount();
    if (response.isSuccess) {
      final data = response.data;
      pagingController.appendPageData(data?.list ?? []);
      state.recordRx.value = data;
    } else {
      pagingController.error = response.errorMessage;
    }
  }


}
