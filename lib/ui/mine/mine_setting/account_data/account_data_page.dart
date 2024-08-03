import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_setting/account_data/widgets/account_data_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
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
        if (info == null) return const SizedBox();

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(
                  top: 24.rpx,
                ),
                children: [
                  AccountDataItem(
                    onTap: controller.onTapHeader,
                    title: "头像",
                    height: 100.rpx,
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.rpx),
                      ),
                      child: AppImage.network(
                        info.avatar ?? "",
                        width: 76.rpx,
                        height: 76.rpx,
                      ),
                    ),
                  ),
                  _padding(),
                  AccountDataItem(
                    onTap: () {
                      Get.toNamed(AppRoutes.updateInfoPage,
                          arguments: {"type": 1});
                    },
                    title: "昵称",
                    detail: info.nickname,
                  ),
                  _padding(),
                  AccountDataItem(
                    onTap: controller.onTapGender,
                    title: "性别",
                    detail: state.getGenderString(info.gender),
                  ),
                  _padding(),
                  AccountDataItem(
                    onTap: () {
                      Pickers.showSinglePicker(
                        context,
                        onConfirm: (value, __) {
                          controller.onConfirmAge(value);
                        },
                        data: List.generate(50, (index) => index + 16),
                      );
                    },
                    title: "年龄",
                    detail: "${info.age ?? ""}",
                  ),
                  _padding(),
                  AccountDataItem(
                    title: "我的位置",
                    detail: info.position,
                  ),
                  _padding(),
                  AccountDataItem(
                    title: "联系电话",
                    detail: info.phone,
                  ),
                  _padding(),
                  AccountDataItem(
                    title: "我的邮箱",
                    detail: info.email,
                  ),
                  _padding(height: 36.rpx),
                  _columnWidget(
                    title: "喜好年龄",
                    detail: "${info.likeAgeMin}-${info.likeAgeMax}",
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        RangeSlider(
                          values: RangeValues(
                            info.likeAgeMin.toDouble(),
                            info.likeAgeMax.toDouble(),
                          ),
                          min: 16,
                          max: 65,
                          onChanged: (value) {
                            debugPrint(value.toString());

                            state.info?.update((val) {
                              val?.likeAgeMin = value.start.toInt();
                              val?.likeAgeMax = value.end.toInt();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "16",
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(AppColor.black9),
                            ),
                            Text(
                              "65",
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(AppColor.black9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _padding(height: 36.rpx),
                  _columnWidget(
                    title: "喜好职业",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _jobButton(0, false),
                        _jobButton(1, false),
                      ],
                    ),
                  ),
                  _padding(height: 36.rpx),
                  _columnWidget(
                    title: "喜好风格",
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
                              selectedBackgroundColor: AppColor.primary,
                              selectedTextColor: Colors.white,
                              borderColor: AppColor.primary,
                              textColor: AppColor.primary,
                            );
                          });
                        }),
                      ),
                    ),
                  ),
                  _padding(height: 36.rpx),
                  _columnWidget(
                    title: "个人简介",
                    child: Container(
                      height: 150.rpx,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.rpx, vertical: 12.rpx),
                      decoration: BoxDecoration(
                        color: AppColor.black9.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      child: InputWidget(
                        hintText: '在这里输入内容',
                        maxLength: 200,
                        lines: 100,
                        fillColor: Colors.transparent,
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
              padding: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(
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
                text: "保存",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  AppTextStyle.st.bold.size(16.rpx).textColor(AppColor.black3),
            ),
            if (detail != null)
              Text(
                detail,
                style: AppTextStyle.st.bold
                    .size(14.rpx)
                    .textColor(AppColor.black3),
              ),
          ],
        ),
        _padding(),
        child,
      ],
    );
  }

  GestureDetector _jobButton(int type, bool isSelect) {
    final String title;
    final String normalPath;
    final String selectPath;
    switch (type) {
      case 0:
        // title = S.current.questionMan;
        title = "在职人员";
        normalPath = "assets/images/mine/job_worker_normal.png";
        selectPath = "assets/images/mine/job_worker_select.png";
        break;
      case 1:
        // title = S.current.questionWoman;
        title = "学生";
        normalPath = "assets/images/mine/job_student_normal.png";
        selectPath = "assets/images/mine/job_student_select.png";
        break;
      default:
        throw Exception("job title error");
    }

    return GestureDetector(
      onTap: () => controller.onTapJob(),
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
            style: AppTextStyle.st.medium
                .size(14.rpx)
                .textColor(AppColor.black3)
                .copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
