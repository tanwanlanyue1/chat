import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/talk_model.dart';

class FortuneSquareState {
  //话题类型
  final topicList = <TopicModel>[].obs;
  //热门话题
  final hotTopic = <TopicModel>[].obs;
  //广场  type:推荐类型 0最新，1热门
  int communityType = 1;
}
