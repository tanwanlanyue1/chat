import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/widgets/filtrate_bottom_sheet.dart';

import 'dating_hall_state.dart';

class RectifyTheWorkplaceController extends GetxController {
  final RectifyTheWorkplaceState state = RectifyTheWorkplaceState();


  //筛选
  void onTapFiltrate(){
    Get.bottomSheet(
      isScrollControlled: true,
        FiltrateBottomSheet()
    );
  }
}
