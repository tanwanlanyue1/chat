import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/label_widget.dart';

class AccountDataState {
  final info = SS.login.info?.copyWith().obs;

  final int ageMin = 16;
  final int ageMax = 65;

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

  String getLikeAgeTitle(UserType type) {
    switch (type) {
      case UserType.user:
      case UserType.beauty:
        return "喜好年龄";
      case UserType.agent:
        return "团队年龄范围";
    }
  }

  String getOccupationTitle(UserType type) {
    switch (type) {
      case UserType.user:
        return "喜好职业";
      case UserType.beauty:
      case UserType.agent:
        return "我的身份";
    }
  }

  String getStyleTitle(UserType type) {
    switch (type) {
      case UserType.user:
        return "喜好风格";
      case UserType.beauty:
        return "我的风格";
      case UserType.agent:
        return "团队风格";
    }
  }
}
