import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lunar/lunar.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/lunar/lunar_manager.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/widgets/photo_view_simple_screen.dart';

class CommonUtils {
  ///[time] 时间
  ///[yearsFlag] 是否要年份
  static getPostTime({String? time, bool yearsFlag = false}) {
    if (time != null) {
      DateTime? recordTime = DateUtil.getDateTime(time, isUtc: false);
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
        result = '昨天 ${DateUtil.formatDate(recordTime, format: 'HH:mm')}';
        return result;
      } else if (dayC > 1) {
        var formate = DateFormats.mo_d_h_m;
        if (yearsFlag) {
          formate = DateFormats.y_mo_d_h_m;
        }
        return DateUtil.formatDate(recordTime, format: formate);
      } else if (hourC >= 1) {
        result = '$hourC小时前';
        return result;
      } else if (minC >= 1) {
        result = '$minC分钟前';
        return result;
      } else {
        result = '刚刚';
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

  ///[time] 时间
  ///秒转天
  static String getSecond({int? time, bool yearsFlag = false}) {
    int days = ((time ?? 0) / (60 * 60 * 24)).floor(); // 计算天数
    int minute = 60;
    int hour = minute * 60;
    var result = '';
    if (days < 365) {
      if (days < 1) {
        if ((time ?? 0) ~/ hour < 1) {
          result = '${(time ?? 0) ~/ minute}' '分';
        } else {
          result = '${(time ?? 0) ~/ hour}' '时';
        }
      } else {
        result = '$days' '天';
      }
    } else {
      result = '${days ~/ 365}' '年';
    }
    return result;
  }

  ///[time] 时间  hideYears 是否隐藏年
  static getCommonTime({String? time, bool hideYears = false}) {
    if (time != null) {
      DateTime? recordTime = DateUtil.getDateTime(time, isUtc: false);
      if (recordTime == null) {
        return '';
      }
      var formate = DateFormats.full; //y_mo_d_h_m;
      if (hideYears) {
        formate = DateFormats.mo_d_h_m;
      }
      return DateUtil.formatDate(recordTime, format: formate);
    }
  }

  ///日期显示(04月16日 星期二)
  static String dateString(String matchTime) {
    if (matchTime.isEmpty) {
      return "";
    }
    DateTime? date = DateUtil.getDateTime(matchTime);
    String today =
        DateUtil.isToday(date?.millisecondsSinceEpoch) == true ? "今天 " : "";
    String weekday = " ${DateUtil.getWeekday(
      date,
      languageCode: "zh",
      short: false,
    )}";

    // "今天 04月16日 星期二"
    return "$today${DateUtil.formatDate(date, format: 'yyyy' + "-" + 'MM' + "-" + 'dd')} ${weekday.toUpperCase()}";
  }

  //阳历转农历
  static Lunar solarToLunar(DateTime solarDate) {
    Lunar lunar = Lunar.fromYmdHms(solarDate.year, solarDate.month,
        solarDate.day, solarDate.hour, solarDate.minute, solarDate.second);
    return lunar;
  }

  // 倒计时转换为时分秒
  static String convertCountdownToHMS(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //农历转阳历
  static Solar lunarToSolar(List<String> lunar) {
    int year = int.parse(lunar[0]);
    int month = LunarManager.lunarMonth[lunar[1]]!;
    int day = LunarManager.lunarDay[lunar[2]]!;
    int hour = LunarManager.lunarTime[lunar[3]]!;
    Lunar lunars = Lunar.fromYmdHms(year, month, day,hour,0,0);
    Solar solar = lunars.getSolar();
    return solar;
  }

  static void saveImage({
    bool failure = false,
    required GlobalKey repaintKey,
    required BuildContext context,
    required Function(bool success, String msg) saveImageCallBack,
  }) async {
    if (failure == false) {
      RenderRepaintBoundary? boundary = repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);
      ByteData? byteData = await image?.toByteData(format: ImageByteFormat.png);
      Uint8List? pageBytes = byteData?.buffer.asUint8List(); //图片data
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(pageBytes!));
      Loading.dismiss();
      if (ObjectUtil.isEmpty(result)) {
        saveImageCallBack(false, '图片保存失败');
      } else {
        saveImageCallBack(true, '图片保存成功');
      }
    } else {
      //保存失败
      Loading.dismiss();
      saveImageCallBack(true, '图片保存失败');
    }
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
