import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_record_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'rosary_beads_detail_state.dart';

class RosaryBeadsDetailController extends GetxController {
  final RosaryBeadsDetailState state = RosaryBeadsDetailState();

  late final pagingController =
  DefaultPagingController<RosaryBeadsRecordModel>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getTodayDirectionRecord();
    if (response.isSuccess) {
      pagingController.appendPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}
