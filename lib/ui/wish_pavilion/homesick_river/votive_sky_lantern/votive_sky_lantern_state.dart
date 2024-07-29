import 'package:get/get.dart';

import '../../../../common/network/api/model/talk_model.dart';

class VotiveSkyLanternState {
  ///天灯类型
  List skyLanternType = [
    {
      "title":"热门",
      "type": -1,
    },
    {
      "title": "婚恋",
      "type": 1,
    },
    {
      "title": "生活",
      "type": 2,
    },
    {
      "title": "学业",
      "type": 3,
    },
    {
      "title": "财运",
      "type": 4,
    },
    {
      "title": "事业",
      "type": 5,
    },
  ];

  final currentIndex = 0.obs;

  ///许愿模版
  List templateData = [];
  //更多模版
  bool moreTemplate = false;

  ///热门天灯
  List<GiftModel> hotLanterns = [];

  ///天灯
  List<GiftModel> votiveSkyLantern = [];

  ///筛选天灯
  List<GiftModel> filtrateData = [];

  //时限 open:0不公开，1公开
  List<TimeConfigModel> timeLimit = [];
}
