import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/label_widget.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:guanjia/widgets/style_tag_widget.dart';
import 'package:guanjia/widgets/system_ui.dart';

import 'question_controller.dart';

/// 注册后问题页面
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
        systemOverlayStyle: SystemUI.lightStyle,
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
        actions: [
          GestureDetector(
            onTap: () => controller.onTapSkip(),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 16.rpx),
                width: 60.rpx,
                height: 26.rpx,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(13.rpx),
                ),
                alignment: Alignment.center,
                child: Text(
                  S.current.questionSkip,
                  style: AppTextStyle.st.medium
                      .size(14.rpx)
                      .textColor(Colors.white),
                ),
              ),
            ),
          ),
        ],
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
          Visibility(
            visible: page == 0,
            replacement: _questionWidget(),
            child: _welcomeWidget(),
          ),
        ],
      ),
    );
  }

  Widget _questionWidget() {
    return Positioned(
      top: Get.mediaQuery.padding.top + kNavigationBarHeight,
      left: 0,
      right: 0,
      bottom: Get.mediaQuery.padding.bottom,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                top: 24.rpx,
                left: 24.rpx,
                right: 24.rpx,
                bottom: 0,
              ),
              child: Column(
                children: [
                  Text(
                    S.current.questionGenderLike,
                    style: AppTextStyle.fs16m.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.rpx),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _likeGenderButton(false),
                      Spacing.w(35),
                      _likeGenderButton(true),
                    ],
                  ),
                  SizedBox(height: 60.rpx),
                  Text(
                    S.current.questionLabelsLike,
                    style: AppTextStyle.fs16m.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.rpx),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<QuestionController>(
                      builder: (controller) {
                        return GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          childAspectRatio: 104 / 40,
                          mainAxisSpacing: 12.rpx,
                          crossAxisSpacing: 16.rpx,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: state.labelItems.map((item) {
                            return StyleTagWidget(
                              icon: item.icon,
                              title: item.title,
                              isSelected: item.selected,
                              color: Colors.white,
                              unselectedColor: Colors.white.withOpacity(0.1),
                              textColor: AppColor.blackBlue,
                              unselectedTextColor: Colors.white,
                              textStyle: AppTextStyle.fs12m,
                              onChanged: (value) {
                                controller.onTapLabel(item);
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.onTapNext(page),
            child: Container(
              height: 50.rpx,
              margin: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx + Get.padding.bottom),
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: StadiumBorder()
              ),
              child: Text(
                S.current.questionFinish,
                style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeWidget() {
    return Positioned(
      top: Get.mediaQuery.padding.top,
      bottom: 0,
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.all(16.rpx),
            child: AspectRatio(
              aspectRatio: 1,
              child: AppImage.asset(
                "assets/images/login/question_0.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              top: Get.width,
              bottom: Get.mediaQuery.padding.bottom,
            ),
            child: Column(
              children: [
                Text(
                  S.current.questionWelcome,
                  style: AppTextStyle.st.medium
                      .size(30.rpx)
                      .textColor(Colors.white),
                ),
                SizedBox(height: 20.rpx),
                SizedBox(
                  width: 247.rpx,
                  child: Text(
                    S.current.questionTip(state.count),
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
                      S.current.questionBegin,
                      style: AppTextStyle.st.medium
                          .size(16.rpx)
                          .textColor(AppColor.blackBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeGenderButton(bool isMan) {
    return Obx(() {
      final bool isSelect;
      if (isMan) {
        isSelect = state.likeGender.value == 1;
      } else {
        isSelect = state.likeGender.value == 2;
      }
      return GestureDetector(
        onTap: () => controller.onTapLikeGender(isMan ? 1 : 2, page),
        child: Container(
          height: 130.rpx,
          width: 130.rpx,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.rpx),
            border: isSelect
                ? Border.all(
                    color: Colors.white,
                    width: 1.5.rpx,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage.asset(
                isMan
                    ? "assets/images/login/man.png"
                    : "assets/images/login/woman.png",
                size: 40.rpx,
              ),
              SizedBox(height: 8.rpx),
              Text(
                isMan ? S.current.questionMan : S.current.questionWoman,
                style: AppTextStyle.fs14m.copyWith(
                  color:
                      isSelect ? Colors.white : Colors.white.withOpacity(0.5),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

// Widget _createdQuestionWidget(int number) {
//   ({Widget widget, double top}) subWidget() {
//     switch (number) {
//       case 1:
//         return (widget: _genderWidget(), top: Get.width - 52.rpx);
//       case 2:
//         return (widget: _birthdayWidget(), top: Get.width - 52.rpx);
//       case 3:
//         return (widget: _likeGenderWidget(), top: Get.width - 52.rpx);
//       case 4:
//         return (widget: _welcomeWidget(), top: Get.width - 52.rpx);
//       default:
//         return (widget: _welcomeWidget(), top: Get.width);
//     }
//   }
//
//   return SingleChildScrollView(
//     physics: const ClampingScrollPhysics(),
//     padding: EdgeInsets.only(
//       top: subWidget().top,
//       bottom: Get.mediaQuery.padding.bottom,
//     ),
//     child: subWidget().widget,
//   );
// }
//
//
// Widget _genderWidget() {
//   Widget genderButton(bool isBoy) {
//     return Obx(() {
//       var isSelect = state.gender.value == isBoy;
//       return _genderButton(isBoy, isSelect);
//     });
//   }
//
//   return Column(
//     children: [
//       Text(
//         "请选择您的性别：",
//         style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
//       ),
//       SizedBox(height: 32.rpx),
//       genderButton(true),
//       SizedBox(height: 16.rpx),
//       genderButton(false),
//     ],
//   );
// }
//
// Widget _birthdayWidget() {
//   return Column(
//     children: [
//       Text(
//         "请输入您的生日：",
//         style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
//       ),
//       SizedBox(height: 32.rpx),
//       SizedBox(height: 16.rpx),
//     ],
//   );
// }
//
// Widget _likeGenderWidget() {
//   Widget genderButton(bool isBoy) {
//     return Obx(() {
//       var isSelect = state.likeGender.value == isBoy;
//       return _genderButton(isBoy, isSelect);
//     });
//   }
//
//   return Column(
//     children: [
//       Text(
//         "您喜欢的对象是？",
//         style: AppTextStyle.st.medium.size(18.rpx).textColor(Colors.white),
//       ),
//       SizedBox(height: 32.rpx),
//       genderButton(true),
//       SizedBox(height: 16.rpx),
//       genderButton(false),
//     ],
//   );
// }
//
// GestureDetector _genderButton(bool isBoy, bool isSelect) {
//   return GestureDetector(
//     onTap: () => controller.onTapGender(isBoy, page),
//     child: Container(
//       margin: EdgeInsets.symmetric(horizontal: 32.rpx),
//       padding: EdgeInsets.symmetric(horizontal: 16.rpx),
//       height: 56.rpx,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.rpx),
//       ),
//       child: Row(
//         children: [
//           AppImage.asset(
//             !isSelect
//                 ? "assets/images/login/choose_normal.png"
//                 : "assets/images/login/choose_select.png",
//             width: 24.rpx,
//             height: 24.rpx,
//           ),
//           SizedBox(width: 16.rpx),
//           Text(
//             isBoy ? "男" : "女",
//             style: AppTextStyle.st.medium
//                 .size(16.rpx)
//                 .textColor(AppColor.black3)
//                 .copyWith(height: 1),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
