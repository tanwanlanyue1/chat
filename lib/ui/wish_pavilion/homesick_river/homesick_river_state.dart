
import 'dart:ui';

import 'package:get/get.dart';

import '../../../common/network/api/model/talk_model.dart';

class HomesickRiverState {
  //思亲类型
  List homesickType = [
    "许愿天灯",
    "河灯",
    "我的",
  ];

  //河灯数据
  final riverData = <RecordLightModel?>[].obs;
  final skyData = <RecordLightModel?>[].obs;
  //河灯全部数据
  List<RecordLightModel?> allData = [];
  //天灯全部数据
  List<RecordLightModel?> allSkyData = [];
  //分割的数组
  List<List<RecordLightModel?>> fourSky = [];
  int fourIndex = 1;
  int currentIndex = 0;
  //默认坐标
  Offset defaultPoints = const Offset(200,-80);
  //河灯漂流坐标
  final List<Offset> points = [
    const Offset(200,-80),
    const Offset(200, 0),
    const Offset(160, 80),
    const Offset(230, 200),
    const Offset(110, 250),
  ];
}
