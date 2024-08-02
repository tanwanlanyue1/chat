import 'package:get/state_manager.dart';
import 'package:guanjia/widgets/label_widget.dart';

class QuestionState {
  final count = 2; // 当前问题数量

  final gender = Rxn<bool>(); // 当前选择性别，默认为null

  final likeGender = Rxn<int>(); // 喜好性别 1：男 2：女

  final birthday = Rxn<String>(); // 当前选择生日，默认为null

  final labels = Rxn<List<String>>(); // 当前选择标签，默认为null

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
}
