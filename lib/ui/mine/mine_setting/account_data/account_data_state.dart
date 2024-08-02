import 'package:get/get.dart';
import 'package:guanjia/widgets/label_widget.dart';

class AccountDataState {

  final yearRangeStart = 20.0.obs;
  final yearRangeEnd = 30.0.obs;

  final List<LabelItem> labelItems = [];

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
