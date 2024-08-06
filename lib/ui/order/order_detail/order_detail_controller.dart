import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'order_detail_state.dart';

class OrderDetailController extends GetxController {
  final OrderDetailState state = OrderDetailState();

  void onTapConfirm () {
    Get.toNamed(AppRoutes.orderEvaluationPage);
  }
}
