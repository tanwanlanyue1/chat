import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'cultivation_ranking_state.dart';

class CultivationRankingController extends GetxController {
  final CultivationRankingState state = CultivationRankingState();
  ///type 0=功德值排行 1=累计修行天数排行 2=连续修行排行 3=上香 4=供礼 5=敲诵 6=念珠
  final int type;

  CultivationRankingController(this.type);

  late final pagingController =
  DefaultPagingController<CultivationRankingModel>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRankingList(type);
    if (response.isSuccess) {
      final list = response.data ?? [];
      pagingController.appendPageData(list);
      state.selfRankingRx.value = list.firstWhereOrNull((element) => element.oneself == 1);
    } else {
      pagingController.error = response.errorMessage;
    }
  }


}
