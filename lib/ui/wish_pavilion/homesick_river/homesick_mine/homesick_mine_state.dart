import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../common/network/api/model/talk_model.dart';

class HomesickMineState {

  ///我的祝福类型
  int mineType = 1;

  List mineBottom = [
    {
      "title":"天灯",
      "type":4,
    },
    {
      "title":"全部",
    },
    {
      "title":"河灯",
      "type": 3,
    },
  ];

  RecordDetailsModel recordDetail = RecordDetailsModel.fromJson({});
}
