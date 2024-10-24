import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import 'choose_area_state.dart';

class ChooseAreaController extends GetxController {
  final ChooseAreaState state = ChooseAreaState();
  late final pagingController = DefaultPagingController<String>.single()..addPageRequestListener(fetchPage);

  void fetchPage(int page){
    pagingController.setPageData([
      '中国大陆',
      '中国香港',
      '中国澳门',
      '中国台湾',
    ]);
  }

}
