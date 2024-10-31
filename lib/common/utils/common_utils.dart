import 'dart:ui';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/widgets/photo_view_simple_screen.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  ///[time] 时间
  ///[yearsFlag] 是否要年份
  static getPostTime({int? time, bool yearsFlag = false}) {
    if (time != null) {
      DateTime? recordTime = DateUtil.getDateTimeByMs(time, isUtc: false);
      if (recordTime == null) {
        return '';
      }
      int minute = 1000 * 60;
      int hour = minute * 60;
      int day = hour * 24;
      DateTime now = DateTime.now();

      int diff = now.difference(recordTime).inMilliseconds;
      var result = '';
      if (diff < 0) {
        return result;
      }
      int weekR = diff ~/ (7 * day);
      int dayC = diff ~/ day;
      int hourC = diff ~/ hour;
      int minC = diff ~/ minute;
      if (weekR >= 1) {
        var formate = DateFormats.mo_d_h_m;
        if (yearsFlag) {
          formate = DateFormats.y_mo_d_h_m;
        }
        return DateUtil.formatDate(recordTime, format: formate);
      } else if (dayC == 1 || (hourC < 24 && !isSameDay(recordTime, now))) {
        result = '${S.current.yesterday} ${DateUtil.formatDate(recordTime, format: 'HH:mm')}';
        return result;
      } else if (dayC > 1) {
        var formate = DateFormats.mo_d_h_m;
        if (yearsFlag) {
          formate = DateFormats.y_mo_d_h_m;
        }
        return DateUtil.formatDate(recordTime, format: formate);
      } else if (hourC >= 1) {
        result = S.current.aHoursAgo(hourC);
        return result;
      } else if (minC >= 1) {
        result = S.current.aMinuteAgo(minC);
        return result;
      } else {
        result = S.current.justNow;
        return result;
      }
    }
    return '';
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// [time] 时间
  /// 秒转天
  static int getSecondToDay({int? time}) {
    int days = ((time ?? 0) / (60 * 60 * 24)).floor(); // 计算天数
    return days;
  }

  ///[time] 时间  hideYears 是否隐藏年
  static getCommonTime({int? time, bool hideYears = false}) {
    if (time != null) {
      DateTime? recordTime = DateUtil.getDateTimeByMs(time, isUtc: false);
      if (recordTime == null) {
        return '';
      }
      var formate = DateFormats.y_mo_d_h_m; //y_mo_d_h_m;
      if (hideYears) {
        formate = DateFormats.mo_d_h_m;
      }
      return DateUtil.formatDate(recordTime, format: formate);
    }
  }

  ///日期显示(04月16日 星期二)
  ///lineFeed：换行
  static String dateString(String matchTime, {bool lineFeed = false}) {
    if (matchTime.isEmpty) {
      return "";
    }
    DateTime? date = DateUtil.getDateTime(matchTime);
    String today =
        DateUtil.isToday(date?.millisecondsSinceEpoch) == true ? "${S.current.today} " : "";
    String weekday = " ${DateUtil.getWeekday(
      date,
      languageCode: "zh",
      short: false,
    )}";

    // "今天 04月16日 星期二"
    return lineFeed
        ? "${today.isNotEmpty ? today : weekday.toUpperCase()},${DateUtil.formatDate(date, format: 'MM' + "/" + 'dd')}"
        : "$today${DateUtil.formatDate(date, format: 'yyyy' + "-" + 'MM' + "-" + 'dd')} ${weekday.toUpperCase()}";
  }

  // 倒计时转换为时分秒 格式为 23:23:23
  static String convertCountdownToHMS(
    int seconds, {
    bool hasHours = true,
    bool hasSeconds = true,
  }) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hasHours ? "${hours.toString().padLeft(2, '0')}:" : "";
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr =
        hasSeconds ? ":${remainingSeconds.toString().padLeft(2, '0')}" : "";
    return '$hoursStr$minutesStr$secondsStr';
  }

  ///时间戳
  static String timestamp(int? time,{String? unit}){
    if (time == null) return "";
    int timestampInMilliseconds = time;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    DateFormat dateFormat = DateFormat(unit ?? 'MM-dd HH:00');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  ///时间戳相差的小时
  static int difference(int? timestamp1,int? timestamp2,){
    if (timestamp1 == null || timestamp2 == null) return 0;
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);
    Duration difference = dateTime2.difference(dateTime1);
    double hours = difference.inHours.toDouble();
    return hours.toInt();
  }

  /// 时间戳转字符串
  static String convertTimestampToString(int timestamp, {String? newPattern}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat dateFormat = DateFormat(newPattern ?? DateFormats.full);
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  ///隐藏软键盘
  static hideSoftKeyboard() {
    if (Get.context != null) {
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      bool hasPrimaryFocus = currentFocus.hasPrimaryFocus;
      if (!hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  ///点击查看大图
  static void checkBigImage(String url, {String path = ''}) {
    ImageProvider imageProvider =
        path.isNotEmpty ? AssetImage(path) : NetworkImage(url) as ImageProvider;
    Navigator.of(Get.context!).push(FadeRoute(
        page: PhotoViewSimpleScreen(
      imageProvider: imageProvider,
      heroTag: 'simple',
      loadingChild: (BuildContext context, ImageChunkEvent? event) {
        return Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: const CircularProgressIndicator(),
        );
      },
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
    )));
  }
}
