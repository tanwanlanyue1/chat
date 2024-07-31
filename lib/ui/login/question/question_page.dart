import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'question_controller.dart';

class QuestionPage extends StatelessWidget {
  final int page;

  QuestionPage({super.key, required this.page});

  final controller = Get.put(QuestionController());
  final state = Get.find<QuestionController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.gradientBackgroundBegin,
                    AppColor.gradientBackgroundEnd
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.mediaQuery.padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(16.rpx),
              child: AspectRatio(
                aspectRatio: 1,
                child: AppImage.asset(
                  "assets/images/login/question_$page.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.mediaQuery.padding.top,
            bottom: 0,
            left: 0,
            right: 0,
            child: _createdQuestionWidget(page),
          ),
        ],
      ),
    );
  }

  Widget _createdQuestionWidget(int number) {
    ({Widget widget, double top}) subWidget() {
      switch (number) {
        case 1:
          return (widget: _genderWidget(), top: Get.width - 52.rpx);
        case 2:
          return (widget: _birthdayWidget(), top: Get.width - 52.rpx);
        case 3:
          return (widget: _likeGenderWidget(), top: Get.width - 52.rpx);
        case 4:
          return (widget: _welcomeWidget(), top: Get.width - 52.rpx);
        default:
          return (widget: _welcomeWidget(), top: Get.width);
      }
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        top: subWidget().top,
        bottom: Get.mediaQuery.padding.bottom,
      ),
      child: subWidget().widget,
    );
  }

  Widget _welcomeWidget() {
    return Column(
      children: [
        Text(
          "欢迎使用管佳！",
          style: AppTextStyle.st.medium.size(30.rpx).textColor(Colors.white),
        ),
        SizedBox(height: 20.rpx),
        SizedBox(
          width: 247.rpx,
          child: Text(
            "现在我们有${state.count}个问题可以帮助您找到更为 合您心意的佳丽",
            textAlign: TextAlign.center,
            style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
          ),
        ),
        SizedBox(height: 30.rpx),
        GestureDetector(
          onTap: () => controller.onTapNext(page),
          child: Container(
            width: 200.rpx,
            height: 50.rpx,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: Text(
              "马上开始",
              style: AppTextStyle.st.medium
                  .size(16.rpx)
                  .textColor(AppColor.black3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderWidget() {
    Widget genderButton(bool isBoy) {
      return Obx(() {
        var isSelect = state.gender.value == isBoy;
        return _genderButton(isBoy, isSelect);
      });
    }

    return Column(
      children: [
        Text(
          "请选择您的性别：",
          style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
        ),
        SizedBox(height: 32.rpx),
        genderButton(true),
        SizedBox(height: 16.rpx),
        genderButton(false),
      ],
    );
  }

  Widget _birthdayWidget() {
    return Column(
      children: [
        Text(
          "请输入您的生日：",
          style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
        ),
        SizedBox(height: 32.rpx),
        SizedBox(height: 16.rpx),
      ],
    );
  }

  Widget _likeGenderWidget() {
    Widget genderButton(bool isBoy) {
      return Obx(() {
        var isSelect = state.likeGender.value == isBoy;
        return _genderButton(isBoy, isSelect);
      });
    }

    return Column(
      children: [
        Text(
          "您喜欢的对象是？",
          style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
        ),
        SizedBox(height: 32.rpx),
        genderButton(true),
        SizedBox(height: 16.rpx),
        genderButton(false),
      ],
    );
  }

  GestureDetector _genderButton(bool isBoy, bool isSelect) {
    return GestureDetector(
      onTap: () => controller.onTapGender(isBoy, page),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.rpx),
        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
        height: 56.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        child: Row(
          children: [
            AppImage.asset(
              !isSelect
                  ? "assets/images/login/choose_normal.png"
                  : "assets/images/login/choose_select.png",
              width: 24.rpx,
              height: 24.rpx,
            ),
            SizedBox(width: 16.rpx),
            Text(
              isBoy ? "男" : "女",
              style: AppTextStyle.st.medium
                  .size(16.rpx)
                  .textColor(AppColor.black3)
                  .copyWith(height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
