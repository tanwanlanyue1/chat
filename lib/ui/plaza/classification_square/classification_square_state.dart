import 'package:get/get.dart';

class ClassificationSquareState {
  //话题id
  late int topicId;
  //话题类型 true:专题/ 话题
  late bool topicType;

  List typeList = [
    {"name":"最新"},
    {"name":"热门"},
  ];

  RxInt currentIndex = 0.obs;
}
