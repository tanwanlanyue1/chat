import 'package:get/state_manager.dart';

class QuestionState {
  final count = 2; // 当前问题数量

  final gender = Rxn<bool>(); // 当前选择性别，默认为null

  final likeGender = Rxn<bool>(); // 当前选择喜欢性别，默认为null

  final birthday = Rxn<String>(); // 当前选择生日，默认为null

  final labels = Rxn<List<String>>(); // 当前选择标签，默认为null
}
