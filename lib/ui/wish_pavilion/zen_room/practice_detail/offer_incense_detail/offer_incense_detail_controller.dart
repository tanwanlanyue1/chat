import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/offering_record_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'offer_incense_detail_state.dart';

class OfferIncenseDetailController extends GetxController {
  final OfferIncenseDetailState state = OfferIncenseDetailState();

  late final pagingController =
  DefaultPagingController<OfferingRecordModel>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRecordCountByType(1);
    if (response.isSuccess) {
      pagingController.appendPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}
