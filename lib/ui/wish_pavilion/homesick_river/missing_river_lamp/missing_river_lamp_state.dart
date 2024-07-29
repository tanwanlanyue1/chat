import 'package:get/get.dart';

import '../../../../common/network/api/model/talk_model.dart';

class MissingRiverLampState {
  //选择的河灯下标
  int river = 0;
  //时效id
  final agingCurrent = Rxn<int>();
  //选择的时效
  final selectAging = Rxn<TimeConfigModel>();
  //是否公开
  int open = 0;

  ///河灯-列表
  List<GiftModel> votiveSkyLantern = [];

  //默认时限
  List<TimeConfigModel> timeLimit = [];

  //全部的时限
  List<TimeConfigModel> allTime = [];
}
