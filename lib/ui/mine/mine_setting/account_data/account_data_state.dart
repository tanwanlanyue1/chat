import 'package:get/get.dart';
import 'package:guanjia/widgets/label_widget.dart';

class AccountDataState {

  final yearRangeStart = 20.0.obs;
  final yearRangeEnd = 30.0.obs;

  final labelItems = [
    LabelItem(title: '美食'),
    LabelItem(title: '温事实上可爱'),
    LabelItem(title: '音乐'),
    LabelItem(title: '游戏'),
    LabelItem(title: '旅行'),
    LabelItem(title: '读书'),
    LabelItem(title: '电影'),
    LabelItem(title: '音乐'),
    LabelItem(title: '游戏'),
    LabelItem(title: '旅行'),
    LabelItem(title: '读书'),
  ];

  String? getGenderString(int? gender) {
    switch (gender) {
      case 0:
        return "保密";
      case 1:
        return "男";
      case 2:
        return "女";
      default:
        return null;
    }
  }
}
