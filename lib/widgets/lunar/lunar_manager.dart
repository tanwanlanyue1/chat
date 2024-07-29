import 'package:lunar/lunar.dart';

///农历选择
class LunarManager{
  static Map<int, Map<String, Map<String, List<String>>>> yearsData = {}; //阳历
  static Map<int, Map<String, Map<String, List<String>>>> lunarData = {}; //农历
  static List<String> durationDay = ["未知","甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥"]; //时辰
  static Map<String,int> lunarMonth = {
    "未知": 1,
    "正": 1,
    "二": 2,
    "三": 3,
    "四": 4,
    "五": 5,
    "六": 6,
    "七": 7,
    "八": 8,
    "九": 9,
    "十": 10,
    "冬": 11,
    "腊": 12,
  }; //月
  static Map<String,int> lunarDay = {
    "未知": 1,
    "初一": 1,
    '初二': 2,
    '初三': 3,
    '初四': 4,
    '初五': 5,
    '初六': 6,
    '初七': 7,
    '初八': 8,
    '初九': 9,
    '初十': 10,
    '十一': 11,
    '十二': 12,
    '十三': 13,
    '十四': 14,
    '十五': 15,
    '十六': 16,
    '十七': 17,
    '十八': 18,
    '十九': 19,
    '二十': 20,
    '廿一': 21,
    '廿二': 22,
    '廿三': 23,
    '廿四': 24,
    '廿五': 25,
    '廿六': 26,
    '廿七': 27,
    '廿八': 28,
    '廿九': 29,
    '三十': 30,
  }; //日
  static Map<String,int> lunarTime = {
    "未知": 0,
    "甲子": 23,
    '乙丑': 1,
    '丙寅': 3,
    '丁卯': 5,
    '戊辰': 7,
    '己巳': 9,
    '庚午': 11,
    '辛未': 13,
    '壬申': 15,
    '癸酉': 17,
    '甲戌': 19,
    '乙亥': 21,
  }; //日

  ///阳历
  static void generateSolarYears() {
    List<String> hours = List.generate(24, (index) => "${index + 1}");
    hours.insert(0, "未知");
    for (int year = 1920; year <= 2100; year++) {
      Map<String, Map<String, List<String>>> monthsData = {};
      for (int month = 1; month <= 12; month++) {
        Map<String, List<String>> daysData = {};
        int daysInMonth = DateTime(year, month + 1, 0).day;
        for (int day = 1; day <= daysInMonth; day++) {
          daysData['未知'] = hours;
          daysData[day.toString().padLeft(2, '0')] = hours;
        }
        monthsData['未知'] = daysData;
        monthsData[month.toString().padLeft(2, '0')] = daysData;
      }
      yearsData[year] = monthsData;
    }
  }

  ///农历
  static void generateLunarYears() {
    durationDay.insert(0, "未知");
    for (int year = 1920; year <= 2100; year++) {
      LunarYear lunarYear = LunarYear.fromYear(year);
      List<LunarMonth> monthsInYear = lunarYear.getMonthsInYear();
      Map<String, Map<String, List<String>>> yearData = {};
      for (var month in monthsInYear) {
        String monthName = '${month.isLeap() ? '闰' : ''}${LunarUtil.MONTH[month.getMonth().abs()]}';
        Map<String, List<String>> monthData = {};
        monthData['未知'] = durationDay;
        int dayCount = month.getDayCount();
        for (var day = 1; day <= dayCount; day++) {
          String dayName = LunarUtil.DAY[day];
          monthData[dayName] = durationDay;
        }
        yearData['未知'] = monthData;
        yearData[monthName] = monthData;
      }
      lunarData[year] = yearData;
    }
  }

}