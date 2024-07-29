import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_record_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';

import 'practice_detail_state.dart';

class PracticeDetailController extends GetxController with GetAutoDisposeMixin {
  final PracticeDetailState state = PracticeDetailState();

  late final pagingController =
      DefaultPagingController<CultivationRecordModel>.single()
        ..addPageRequestListener(_fetchRecordsData);

  @override
  void onInit() {
    super.onInit();
    ever(state.selectedItemRx, (_) => pagingController.refresh());
    state.dateItems.addAll(_getRecent7Days());
    state.selectedItemRx.value = state.dateItems.firstWhereOrNull((element) => element.isToday);
    _fetchData();
  }

  void _fetchData() async {
    final response = await WishPavilionApi.getTodayCount();
    if (response.isSuccess) {
      state.cultivationStatsRx.value = response.data;
    } else {
      response.showErrorMessage();
    }
  }

  void _fetchRecordsData(_) async {
    final date = state.selectedItemRx()?.dateTime ?? DateTime.now();
    final response = await WishPavilionApi.getAllRecordByDate(date.formatYMD);
    if (response.isSuccess) {
      pagingController.appendPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  List<PracticeDetailDateItem> _getRecent7Days() {
    final DateTime now = DateTime.now();
    final weekDay = now.weekday;
    final sundayTime = now.subtract(Duration(days: weekDay));

    state.week = DateUtil.getWeekday(now, languageCode: "zh");
    state.day = now.day.toString();
    state.yearAndMonth = DateUtil.formatDate(now, format: "yyyy/MM");

    List<PracticeDetailDateItem> items = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = sundayTime.add(Duration(days: i));
      final weakDay =
          DateUtil.getWeekday(date, languageCode: "zh").substring(2);
      final item = PracticeDetailDateItem(
        dateTime: date,
        weekDay: weakDay,
        day: date.day,
        isToday: date.isToday,
        isFuture: DateTime(date.year, date.month, date.day).isAfter(now.today),
      );

      items.add(item);
    }

    return items;
  }

  void onChangeDate(PracticeDetailDateItem item) {
    //未来的日期不能点
    if(item.isFuture){
      return;
    }
    state.selectedItemRx.value = item;
  }

  void onTapOfferIncenseDetail() {
    Get.toNamed(AppRoutes.offerIncenseDetailPage);
  }

  void onTapTributeDetailPage() {
    Get.toNamed(AppRoutes.tributeDetailPage);
  }

  void onTapWoodenFishDetail() {
    Get.toNamed(AppRoutes.woodenFishDetailPage);
  }

  void onTapRosaryBeadsDetail() {
    Get.toNamed(AppRoutes.rosaryBeadsDetailPage);
  }
}
