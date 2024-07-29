// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/lunar/lunar_manager.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///农历视图
class LunarView extends StatefulWidget {
  final List<String>? defaultSelection;
  final bool? solar;
  final ValueChanged<List<String>> onSelectionChanged;
  LunarView({
    super.key,
    this.defaultSelection,
    this.solar,
    required this.onSelectionChanged,
  });

  @override
  _LunarViewState createState() => _LunarViewState();

  static void show(
      {List<String>? defaultSelection,
      required Function(List<String>) onSelectionChanged}) {
    Get.bottomSheet(
      LunarView(
        defaultSelection: defaultSelection ?? ["2000"],
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}

class _LunarViewState extends State<LunarView> {
  late List<int> years;
  late int selectedYear;
  late List<String> months;
  late String selectedMonth;
  late List<String> days;
  late String selectedDay;
  late List<String> hours;
  late String selectedHour;
  //默认选中项
  List<String> defaultSelection = [];

  ///控制器：用来初始化选中项
  FixedExtentScrollController yearScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController monthScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController dayScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController hourScrollController =
      FixedExtentScrollController();
  bool solar = true; //阴历/阳历
  Map<int, Map<String, Map<String, List<String>>>> columnData =
      LunarManager.yearsData; //日历数据

  @override
  void initState() {
    super.initState();
    solar = widget.solar ?? true;
    defaultSelection = widget.defaultSelection ?? [];
    initData();
    initialItem();
  }

  initialItem() {
    yearScrollController =
        FixedExtentScrollController(initialItem: years.indexOf(selectedYear));
    monthScrollController =
        FixedExtentScrollController(initialItem: months.indexOf(selectedMonth));
    dayScrollController =
        FixedExtentScrollController(initialItem: days.indexOf(selectedDay));
    hourScrollController =
        FixedExtentScrollController(initialItem: hours.indexOf(selectedHour));
  }

  ///初始化数据
  initData() {
    columnData = solar ? LunarManager.yearsData : LunarManager.lunarData;
    years = columnData.keys.toList();
    if (defaultSelection.isNotEmpty &&
        columnData.containsKey(int.parse(defaultSelection[0]))) {
      selectedYear = int.parse(defaultSelection[0]);
      months = columnData[selectedYear]!.keys.toList();
      selectedMonth = defaultSelection.length > 1 &&
              columnData[selectedYear]!.containsKey(defaultSelection[1])
          ? defaultSelection[1]
          : months[0];
      days = columnData[selectedYear]![selectedMonth]!.keys.toList();
      selectedDay = defaultSelection.length > 2 &&
              columnData[selectedYear]![selectedMonth]!
                  .containsKey(defaultSelection[2])
          ? defaultSelection[2]
          : days[0];
      hours = columnData[selectedYear]![selectedMonth]![selectedDay] ?? [];
      selectedHour =
          defaultSelection.length > 3 && hours.contains(defaultSelection[3])
              ? defaultSelection[3]
              : hours.isNotEmpty
                  ? hours[0]
                  : '';
    } else {
      selectedYear = years[0];
      months = columnData[selectedYear]!.keys.toList();
      selectedMonth = months[0];
      days = columnData[selectedYear]![selectedMonth]!.keys.toList();
      selectedDay = days[0];
      hours = columnData[selectedYear]![selectedMonth]![selectedDay] ?? [];
      selectedHour = hours.isNotEmpty ? hours[0] : '';
    }
    yearScrollController.jumpToItem(years.indexOf(selectedYear));
    monthScrollController.jumpToItem(months.indexOf(selectedMonth));
    dayScrollController.jumpToItem(days.indexOf(selectedDay));
    hourScrollController.jumpToItem(hours.indexOf(selectedHour));
    setState(() {});
  }

  ///单位
  String unit(int type) {
    switch (type) {
      case 0:
        return "年";
      case 1:
        return "月";
      case 2:
        return "日";
      case 3:
        return "时";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.rpx,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rpx),
          topRight: Radius.circular(20.rpx),
        ),
      ),
      padding: EdgeInsets.only(top: 19.rpx, left: 12.rpx, right: 12.rpx),
      child: Column(
        children: [
          SizedBox(
            height: 45.rpx,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xff8D310F),
                  ),
                ),
                Container(
                  height: 30.rpx,
                  width: 100.rpx,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.rpx)),
                    border: Border.all(
                        width: 1.rpx, color: const Color(0xff8D310F)),
                  ),
                  margin: EdgeInsets.only(left: 50.rpx),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            solar = !solar;
                            initData();
                          },
                          child: Container(
                            width: 50.rpx,
                            height: 30.rpx,
                            decoration: BoxDecoration(
                              color: solar
                                  ? const Color.fromRGBO(141, 49, 15, 0.15)
                                  : null,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.rpx),
                                bottomLeft: Radius.circular(10.rpx),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "阳历",
                              style: TextStyle(
                                  color: const Color(0xff8D310F),
                                  fontSize: 16.rpx),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            solar = !solar;
                            initData();
                          },
                          child: Container(
                            width: 50.rpx,
                            height: 30.rpx,
                            decoration: BoxDecoration(
                              color: !solar
                                  ? const Color.fromRGBO(141, 49, 15, 0.15)
                                  : null,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.rpx),
                                bottomRight: Radius.circular(10.rpx),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "农历",
                              style: TextStyle(
                                  color: const Color(0xff8D310F),
                                  fontSize: 16.rpx),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 56.rpx,
                    height: 56.rpx,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      "确定",
                      style: TextStyle(
                          color: const Color(0xff8D310F), fontSize: 14.rpx),
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    _notifySelectionChanged();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: pickerView(years, years.indexOf(selectedYear),
                      type: 0,
                      scrollController: yearScrollController, (int index) {
                    selectedYear = years[index];
                    updateMonthAndDay(selectedYear, selectedMonth);
                  }),
                ),
                Expanded(
                  child: pickerView(months, months.indexOf(selectedMonth),
                      type: 1,
                      scrollController: monthScrollController, (int index) {
                    selectedMonth = months[index];
                    updateMonthAndDay(selectedYear, selectedMonth);
                  }),
                ),
                Expanded(
                  child: pickerView(days, days.indexOf(selectedDay),
                      type: 2,
                      scrollController: dayScrollController, (int index) {
                    selectedDay = days[index];
                    updateHour(selectedYear, selectedMonth, selectedDay);
                  }),
                ),
                Expanded(
                  child: pickerView(hours, hours.indexOf(selectedHour),
                      type: 3,
                      scrollController: hourScrollController, (int index) {
                    selectedHour = hours[index];
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pickerView(
      List<dynamic> items, int selectedIndex, ValueChanged<int> onChanged,
      {required int type, FixedExtentScrollController? scrollController}) {
    return CupertinoPicker.builder(
      itemExtent: 50,
      onSelectedItemChanged: onChanged,
      childCount: items.length,
      scrollController: scrollController,
      selectionOverlay: Container(
        alignment: Alignment.center,
        color: const Color(0xffEEE0DB).withOpacity(0.3), // 选中项的背景色
      ),
      itemBuilder: (_, index) {
        return Center(
          child: Text(
            '${items[index]}${unit(type)}',
            style: TextStyle(
              color: const Color(0xff333333),
              fontSize: 14.rpx,
            ),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }

  void updateMonthAndDay(int year, String selectedMonth) {
    setState(() {
      months = columnData[year]!.keys.toList();
      if (!months.contains(selectedMonth)) {
        selectedMonth = months[0];
      } else {
        selectedMonth = selectedMonth;
      }
      days = columnData[year]![selectedMonth]!.keys.toList();
      if (!days.contains(selectedDay)) {
        selectedDay = days[0];
      }
    });
  }

  void updateHour(int year, String selectedMonth, String selectedDay) {
    setState(() {
      hours = columnData[year]![selectedMonth]![selectedDay] ?? [];
      selectedHour = hours.isNotEmpty ? hours[0] : '';
    });
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged([
      selectedYear.toString(),
      selectedMonth,
      selectedDay,
      selectedHour,
      '$solar'
    ]);
  }
}
