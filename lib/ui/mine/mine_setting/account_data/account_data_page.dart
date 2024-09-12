import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_setting/account_data/widgets/account_data_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/gradient_range_slider_thumb.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/label_widget.dart';

import 'account_data_controller.dart';

///个人信息
class AccountDataPage extends StatelessWidget {
  AccountDataPage({super.key});

  final controller = Get.put(AccountDataController());

  final state = Get.find<AccountDataController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.personalInformation),
      ),
      body: Obx(() {
        final info = state.info?.value;
        final userInfoRx = controller.loginService.info;
        if (info == null) return const SizedBox();

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(
                  top: 24.rpx,
                ),
                children: [
                  // header
                  AccountDataItem(
                    onTap: controller.onTapAvatar,
                    title: S.current.userAvatar,
                    height: 100.rpx,
                    trailing: AppImage.network(
                      controller.avatarController.avatar.value,
                      borderRadius: BorderRadius.circular(4.rpx),
                      width: 66.rpx,
                      height: 66.rpx,
                    ),
                  ),
                  _padding(),
                  // nickname
                  AccountDataItem(
                    title: S.current.userNickName,
                    trailing: InputWidget(
                      inputController: controller.nicknameController,
                      hintText: "",
                      textAlign: TextAlign.right,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      textStyle:
                          AppTextStyle.fs16b.textColor(AppColor.blackBlue),
                    ),
                  ),
                  _padding(),
                  // gender
                  AccountDataItem(
                    onTap: controller.onTapGender,
                    title: S.current.userGender,
                    detail: state.getGenderString(info.gender),
                    detailHintText: "点击输入",
                  ),
                  _padding(),
                  // age
                  AccountDataItem(
                    onTap: () {
                      Pickers.showSinglePicker(
                        context,
                        pickerStyle: PickerStyle(
                          cancelButton: Padding(
                            padding: FEdgeInsets(horizontal: 16.rpx),
                            child: Text(
                              '取消',
                              style: AppTextStyle.fs14b.copyWith(color: AppColor.black999),
                            ),
                          ),
                          commitButton: Padding(
                            padding: FEdgeInsets(horizontal: 16.rpx),
                            child: Text(
                              '确定',
                              style: AppTextStyle.fs14b,
                            ),
                          ),
                        ),
                        selectData: info.age ?? 24,
                        onConfirm: (value, __) {
                          controller.onConfirmAge(value);
                        },
                        data: List.generate(50, (index) => index + 16),
                      );
                    },
                    title: S.current.userAge,
                    detail: info.age?.toString(),
                    detailHintText: "点击输入",
                  ),
                  _padding(),
                  // position
                  AccountDataItem(
                    onTap: controller.onTapPosition,
                    title: S.current.userPosition,
                    detail: info.position,
                    detailHintText: "点击输入",
                  ),
                  _padding(),
                  // phone
                  AccountDataItem(
                    onTap: controller.onTapPhone,
                    title: S.current.userPhone,
                    detail: userInfoRx?.phone,
                    detailHintText: "点击绑定手机电话",
                  ),
                  _padding(),
                  // email
                  AccountDataItem(
                    onTap: controller.onTapEmail,
                    title: S.current.userEmail,
                    detail: userInfoRx?.email,
                    detailHintText: "点击绑定邮箱",
                  ),
                  // likeSex
                  if (info.type.isUser)
                    _columnWidget(
                      title: S.current.userLikeGender,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _genderButton(UserGender.male, info),
                          _genderButton(UserGender.female, info),
                        ],
                      ),
                    ),
                  // likeAge
                  _columnWidget(
                    title: state.getLikeAgeTitle(info.type),
                    detail: "${info.likeAgeMin}-${info.likeAgeMax}",
                    child: SizedBox(
                      height: 46.rpx,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 30.rpx,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                rangeTrackShape: CustomRangeSliderTrackShape(),
                                rangeThumbShape:
                                    GradientRangeSliderThumbShape(),
                              ),
                              child: RangeSlider(
                                values: RangeValues(
                                  info.likeAgeMin.toDouble(),
                                  info.likeAgeMax.toDouble(),
                                ),
                                min: state.ageMin.toDouble(),
                                max: state.ageMax.toDouble(),
                                onChanged: (value) {
                                  controller.onChangeLikeAge(
                                      value.start.toInt(), value.end.toInt());
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.ageMin.toString(),
                                  style: AppTextStyle.st.medium
                                      .size(14.rpx)
                                      .textColor(AppColor.black9)
                                      .textHeight(1),
                                ),
                                Text(
                                  state.ageMax.toString(),
                                  style: AppTextStyle.st.medium
                                      .size(14.rpx)
                                      .textColor(AppColor.black9)
                                      .textHeight(1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // occupation
                  _columnWidget(
                    title: state.getOccupationTitle(info.type),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _jobButton(UserOccupation.employees, info),
                        _jobButton(UserOccupation.student, info),
                      ],
                    ),
                  ),
                  // style
                  _columnWidget(
                    title: state.getStyleTitle(info.type),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 12.rpx,
                        runSpacing: 12.rpx,
                        children:
                            List.generate(state.labelItems.length, (index) {
                          return GetBuilder<AccountDataController>(
                              builder: (controller) {
                            final item = state.labelItems[index];
                            return LabelWidget(
                              onTap: () => controller.onTapLabel(item),
                              item: item,
                              selectedBackgroundColor: AppColor.primaryBlue,
                              selectedTextColor: Colors.white,
                              borderColor: AppColor.primaryBlue,
                              textColor: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(4.rpx),
                              height: 42.rpx,
                            );
                          });
                        }),
                      ),
                    ),
                  ),
                  // signature
                  _columnWidget(
                    title: S.current.userSignature,
                    child: Container(
                      height: 150.rpx,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.rpx, vertical: 12.rpx),
                      decoration: BoxDecoration(
                        color: AppColor.black9.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      child: InputWidget(
                        hintText: S.current.userSignatureHint,
                        maxLength: 200,
                        lines: 100,
                        fillColor: Colors.transparent,
                        keyboardType: TextInputType.multiline,
                        textAction: TextInputAction.newline,
                        inputController: controller.signatureController,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  _padding(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16 .rpx).copyWith(
                  top: 14.rpx, bottom: 14.rpx + Get.mediaQuery.padding.bottom),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ]),
              child: CommonGradientButton(
                onTap: controller.onTapSave,
                text: S.current.save,
                height: 50.rpx,
              ),
            ),
          ],
        );
      }),
    );
  }

  SizedBox _padding({double? height}) {
    return SizedBox(height: height ?? 16.rpx);
  }

  Widget _columnWidget({
    required String title,
    String? detail,
    required Widget child,
  }) {
    return Column(
      children: [
        _padding(height: 36.rpx),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.fs18b.textColor(AppColor.blackBlue),
            ),
            if (detail != null)
              Text(
                detail,
                style: AppTextStyle.fs14b.textColor(AppColor.blackBlue),
              ),
          ],
        ),
        _padding(),
        child,
      ],
    );
  }

  Widget _genderButton(UserGender gender, UserModel info) {
    final bool isSelect = info.likeSex == gender;

    final String title = gender.isMale ? S.current.male : S.current.female;
    const String normalPath = "assets/images/mine/gender_choose_normal.png";
    const String selectPath = "assets/images/mine/gender_choose_select.png";

    return GestureDetector(
      onTap: () => controller.onTapLikeGender(gender),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage.asset(
            isSelect ? selectPath : normalPath,
            width: 20.rpx,
            height: 20.rpx,
          ),
          SizedBox(width: 4.rpx),
          Text(title,
              style: AppTextStyle.fs14b
                  .textColor(AppColor.blackBlue)),
        ],
      ),
    );
  }

  Widget _jobButton(UserOccupation occupation, UserModel info) {
    final bool isSelect = info.type.isUser
        ? info.likeOccupation == occupation
        : info.occupation == occupation;

    final String title;
    final String normalPath;
    final String selectPath;
    switch (occupation) {
      case UserOccupation.employees:
        title = S.current.employees;
        normalPath = "assets/images/mine/job_worker_normal.png";
        selectPath = "assets/images/mine/job_worker_select.png";
        break;
      case UserOccupation.student:
        title = S.current.student;
        normalPath = "assets/images/mine/job_student_normal.png";
        selectPath = "assets/images/mine/job_student_select.png";
        break;
      default:
        throw Exception("occupation is not exit");
    }

    return GestureDetector(
      onTap: () => controller.onTapOccupation(occupation, info),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage.asset(
            isSelect ? selectPath : normalPath,
            width: 60.rpx,
            height: 60.rpx,
          ),
          SizedBox(height: 8.rpx),
          Text(
            title,
            style: AppTextStyle.fs12b
                .textColor(AppColor.blackBlue)
                .copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
