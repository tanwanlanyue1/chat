import 'package:get/state_manager.dart';
import 'package:guanjia/widgets/label_widget.dart';

class QuestionState {
  final count = 2; // 当前问题数量

  final gender = Rxn<bool>(); // 当前选择性别，默认为null

  final likeGender = 2.obs; // 喜好性别 1：男 2：女

  final birthday = Rxn<String>(); // 当前选择生日，默认为null

  final List<LabelItem> labelItems = []; // 标签
}
