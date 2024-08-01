import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/label_widget.dart';

import 'question_state.dart';

class QuestionController extends GetxController {
  final QuestionState state = QuestionState();

  void onTapSkip() {
    Get.backToRoot();
  }

  void onTapNext(int page) {
    if (page < 1) {
      Get.toNamed(
        AppRoutes.loginQuestionPage,
        arguments: {"page": page + 1},
        preventDuplicates: false,
      );
      return;
    }
    Get.backToRoot();
  }

  void onTapGender(bool gender, int page) {
    state.gender.value = gender;
  }

  void onTapLikeGender(bool gender, int page) {
    state.likeGender.value = gender;

    onTapNext(page);
  }

  void onTapLabel(LabelItem item) {
    item.selected = !item.selected;
    update();
  }
}
