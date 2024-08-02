import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/label_widget.dart';
import 'package:guanjia/widgets/loading.dart';

import 'question_state.dart';

class QuestionController extends GetxController {
  final QuestionState state = QuestionState();

  @override
  void onInit() {
    SS.appConfig.configRx.value?.labels?.forEach((element) {
      state.labelItems.add(LabelItem(
        id: element.id,
        title: element.tag,
      ));
    });

    super.onInit();
  }

  void onTapSkip() {
    _goHome();
  }

  void onTapNext(int page) async {
    if (page < 1) {
      Get.toNamed(
        AppRoutes.loginQuestionPage,
        arguments: {"page": page + 1},
        preventDuplicates: false,
      );
      return;
    }

    final selectedIdString = state.labelItems
        .where((item) => item.selected)
        .map((item) => item.id.toString())
        .join(',');

    if (state.likeGender.value == null && selectedIdString.isEmpty) {
      _goHome();
      return;
    }

    Loading.show();
    final res = await SS.login.initUserInfo(
      likeSex: state.likeGender.value,
      likeStyle: selectedIdString.isEmpty ? null : selectedIdString,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    SS.login.fetchMyInfo();

    _goHome();
  }

  void onTapGender(bool gender, int page) {
    state.gender.value = gender;
  }

  void onTapLikeGender(int gender, int page) {
    state.likeGender.value = gender;
  }

  void onTapLabel(LabelItem item) {
    item.selected = !item.selected;
    update();
  }

  void _goHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
