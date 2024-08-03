import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/label_widget.dart';

class AccountDataState {
  final info = SS.login.info?.copyWith().obs;

  final int ageMin = 16;
  final int ageMax = 65;

  final List<LabelItem> labelItems = [];

  String? getGenderString(UserGender? gender) {
    switch (gender) {
      case UserGender.male:
        return S.current.male;
      case UserGender.female:
        return S.current.female;
      default:
        return null;
    }
  }

  String getLikeAgeTitle(UserType type) {
    switch (type) {
      case UserType.user:
      case UserType.beauty:
        return S.current.userLikeAge;
      case UserType.agent:
        return S.current.userGroupAge;
    }
  }

  String getOccupationTitle(UserType type) {
    switch (type) {
      case UserType.user:
        return S.current.userLikeOccupation;
      case UserType.beauty:
      case UserType.agent:
        return S.current.userOccupation;
    }
  }

  String getStyleTitle(UserType type) {
    switch (type) {
      case UserType.user:
        return S.current.userLikeStyle;
      case UserType.beauty:
        return S.current.userStyle;
      case UserType.agent:
        return S.current.userGroupStyle;
    }
  }
}
