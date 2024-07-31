import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'question_state.dart';

class QuestionController extends GetxController {
  final QuestionState state = QuestionState();

  void onTapNext(int page) {
    if (page != state.count) {
      Get.toNamed(
        AppRoutes.loginQuestionPage,
        arguments: {"page": page + 1},
        preventDuplicates: false,
      );
    }
  }

  void onTapGender(bool gender, int page) {
    state.gender.value = gender;

    onTapNext(page);
  }

  void onTapLikeGender(bool gender, int page) {
    state.likeGender.value = gender;

    onTapNext(page);
  }
}
