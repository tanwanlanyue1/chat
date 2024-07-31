import 'package:get/state_manager.dart';

class QuestionState {
  final count = 2; // 当前问题数量

  final gender = Rxn<bool>(); // 当前选择性别，默认为null

  final likeGender = Rxn<bool>(); // 当前选择喜欢性别，默认为null

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
  ].obs;
}

class LabelItem {
  final String title;
  bool selected;

  LabelItem({
    required this.title,
    this.selected = false,
  });
}
