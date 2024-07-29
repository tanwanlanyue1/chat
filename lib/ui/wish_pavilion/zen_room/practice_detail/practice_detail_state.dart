import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/today_cultivation_stats_model.dart';


class PracticeDetailState {

  String day = "";

  String week = "";

  String yearAndMonth = "";

  final dateItems = <PracticeDetailDateItem>[];

  ///当前选中的日期
  final selectedItemRx = Rxn<PracticeDetailDateItem>();

  ///修行统计
  final cultivationStatsRx = Rxn<TodayCultivationStatsModel>();
}

class PracticeDetailDateItem {
  final DateTime dateTime;
  final String weekDay;
  final int day;
  final bool isToday;
  final bool isFuture;

  PracticeDetailDateItem({
    required this.dateTime,
    required this.weekDay,
    required this.day,
    this.isToday = false,
    this.isFuture = false,
  });
}
