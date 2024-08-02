import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/widgets/label_widget.dart';

class AccountDataState {
  final gender = Rxn<UserGender>(); // 性别

  final likeGender = Rxn<UserGender>(); // 喜好性别

  final yearRangeStart = 18.obs;
  final yearRangeEnd = 40.obs;

  final List<LabelItem> labelItems = [];

  String? getGenderString(UserGender? gender) {
    switch (gender) {
      case UserGender.male:
        return "男";
      case UserGender.female:
        return "女";
      default:
        return null;
    }
  }
}
