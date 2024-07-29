
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/votive_sky_lantern/votive_sky_lantern_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../../common/network/api/model/talk_model.dart';

///许愿天灯弹窗
class SkyLanternBottomSheet {
  static void show({
    required GiftModel item,
    Function()? callback,
  }) {
    Get.bottomSheet(
      GetBuilder<VotiveSkyLanternController>(
        id: "bottomSheet",
        init: VotiveSkyLanternController(),
        builder: (controller) {
          return Container(
            height: Get.height * 0.8,
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.rpx),
                topRight: Radius.circular(20.rpx),
              ),
            ),
            padding: EdgeInsets.only(bottom: 8.rpx),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 50.rpx,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 40.rpx),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "许愿天灯",
                              style: TextStyle(
                                  fontSize: 18.rpx,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff684326)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 40.rpx,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.close,
                              color: Color(0xff684326),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.rpx, vertical: 8.rpx),
                      children: [
                        Row(
                          children: [
                            AppImage.network(
                              item.image,
                              width: 60.rpx,
                              height: 90.rpx,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFF1D5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.rpx))),
                                padding: EdgeInsets.only(
                                    top: 4.rpx,
                                    left: 12.rpx,
                                    right: 12.rpx,
                                    bottom: 8.rpx),
                                child: RichText(
                                  text: TextSpan(
                                    text: "${item.name}\n",
                                    style: TextStyle(
                                        color: const Color(0xff8D310F),
                                        fontSize: 16.rpx,
                                        fontWeight: FontWeight.bold,
                                        height: 2),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: item.remark,
                                        style: TextStyle(
                                            color: const Color(0xff8D310F),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.rpx,
                                            height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 8.rpx),
                          child: Text(
                            "天灯完愿后可获得功德 ",
                            style: TextStyle(
                                color: const Color(0xff666666),
                                fontSize: 12.rpx),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.rpx),
                          child: Text(
                            "虔诚祈求，愿：",
                            style: TextStyle(
                                color: const Color(0xff333333),
                                fontSize: 16.rpx),
                          ),
                        ),
                        InputWidget(
                          hintText: '请写下接福者的姓名，可以是自己',
                          fillColor: const Color(0xffFFFFFF),
                          inputController: controller.benedictionController,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xffE6E6E6), width: 1.rpx),
                              borderRadius: BorderRadius.circular(8.rpx)),
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 16.rpx, bottom: 8.rpx),
                                  height: 30.rpx,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: List.generate(
                                              controller.state.templateData
                                                          .length >
                                                      4
                                                  ? 4
                                                  : controller
                                                      .state
                                                      .templateData
                                                      .length, (i) {
                                            var templateItem = controller
                                                .state.templateData[i];
                                            return GestureDetector(
                                              onTap: () {
                                                controller.wishInputController
                                                        .text =
                                                    templateItem[templateItem
                                                        .keys.first];
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    right: 12.rpx),
                                                height: 24.rpx,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.rpx),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff8D310F),
                                                    border: Border.all(
                                                        width: 1.rpx,
                                                        color: const Color
                                                            .fromRGBO(
                                                            141, 49, 15, 0.15)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.rpx))),
                                                child: Text(
                                                  "${templateItem.keys.first}",
                                                  style: TextStyle(
                                                      fontSize: 12.rpx,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.state.moreTemplate =
                                              !controller.state.moreTemplate;
                                          controller.update(['bottomSheet']);
                                        },
                                        child: Text(
                                          "更多模版 >",
                                          style: TextStyle(
                                              color: const Color(0xff333333),
                                              fontSize: 14.rpx),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.rpx, color: AppColor.gray12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.rpx))),
                                  padding: EdgeInsets.only(top: 6.rpx),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InputWidget(
                                        hintText: '请写下您的愿望',
                                        lines: 5,
                                        maxLength: 199,
                                        counterText: '',
                                        fillColor: Colors.white,
                                        inputController:
                                            controller.wishInputController,
                                        onChanged: (_) {
                                          controller.update(["bottomSheet"]);
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.rpx),
                                        child: Text(
                                          " ${controller.wishInputController.text.length}/199",
                                          style: AppTextStyle.fs14m
                                              .copyWith(color: AppColor.gray9),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller.state.moreTemplate,
                              child: Positioned(
                                right: 12.rpx,
                                top: 48.rpx,
                                child: Container(
                                  width: 272.rpx,
                                  height: 120.rpx,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.5), // 阴影颜色
                                        spreadRadius: 5, // 阴影扩散程度
                                        blurRadius: 7, // 阴影模糊程度
                                        offset: const Offset(0, 3), // 阴影偏移量
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.rpx)),
                                  ),
                                  padding: EdgeInsets.all(8.rpx),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4.rpx),
                                    child: Wrap(
                                      spacing: 12.rpx,
                                      runSpacing: 12.rpx,
                                      children: List.generate(
                                          controller.state.templateData
                                              .length, (i) {
                                        var templateItem =
                                        controller.state.templateData[i];
                                        return GestureDetector(
                                          onTap: () {
                                            controller.wishInputController
                                                .text =
                                            templateItem[
                                            templateItem.keys.first];
                                            controller.state.moreTemplate =
                                            false;
                                            controller
                                                .update(['bottomSheet']);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 24.rpx,
                                            width: 40.rpx,
                                            decoration: BoxDecoration(
                                                color:
                                                const Color(0xff8D310F),
                                                border: Border.all(
                                                    width: 1.rpx,
                                                    color:
                                                    const Color.fromRGBO(
                                                        141,
                                                        49,
                                                        15,
                                                        0.15)),
                                                borderRadius:
                                                BorderRadius.all(Radius
                                                    .circular(4.rpx))),
                                            child: Text(
                                              "${templateItem.keys.first}",
                                              style: TextStyle(
                                                  fontSize: 12.rpx,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: List.generate(
                            controller.state.timeLimit.length,
                            (i) {
                              bool select =
                                  controller.state.currentIndex.value == i;
                              var time = controller.state.timeLimit[i];
                              return GestureDetector(
                                onTap: () {
                                  if (time.goldNum == 0 &&
                                      time.surplusCount == 0) {
                                    Loading.showToast('暂无免费次数！');
                                  } else {
                                    controller.state.currentIndex.value = i;
                                    controller.update(['bottomSheet']);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.rpx),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      select
                                          ? AppImage.asset(
                                              "assets/images/wish_pavilion/homesick/pitch_on.png",
                                              width: 20.rpx,
                                              height: 20.rpx,
                                            )
                                          : AppImage.asset(
                                              "assets/images/wish_pavilion/homesick/unselected.png",
                                              width: 20.rpx,
                                              height: 20.rpx,
                                            ),
                                      Expanded(
                                        child: Container(
                                          height: 40.rpx,
                                          margin: EdgeInsets.only(left: 12.rpx),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.rpx),
                                          decoration: BoxDecoration(
                                              color: select
                                                  ? AppColor.gold7
                                                  : Colors.white,
                                              border: Border.all(
                                                  width: 1.rpx,
                                                  color: select
                                                      ? AppColor.gold8
                                                      : AppColor.gray12),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.rpx))),
                                          child: Row(
                                            children: [
                                              Text(
                                                time.acquiesce == 1
                                                    ? "许愿仅自己可见"
                                                    : "公开，接受众人祝福",
                                                style: AppTextStyle.fs14m
                                                    .copyWith(
                                                        color: select
                                                            ? AppColor.red1
                                                            : AppColor.gray9),
                                              ),
                                              const Spacer(),
                                              Text(
                                                CommonUtils.getSecond(time: time.periodTime),
                                                style: AppTextStyle.fs16b
                                                    .copyWith(
                                                        color: select
                                                            ? AppColor.red1
                                                            : AppColor.gray9),
                                              ),
                                              const Spacer(),
                                              Visibility(
                                                visible: i == 0,
                                                replacement: AppImage.asset(
                                                  "assets/images/mine/mine_gold16.png",
                                                  width: 20.rpx,
                                                  height: 20.rpx,
                                                ),
                                                child: Text(
                                                  "（${time.surplusCount}/${time.freeCount}）",
                                                  style: AppTextStyle.fs14m
                                                      .copyWith(
                                                          color: select
                                                              ? AppColor.red1
                                                              : AppColor.gray9),
                                                ),
                                              ),
                                              Text(
                                                " ${time.goldNum == 0 ? "免费" : time.goldNum}",
                                                style: AppTextStyle.fs14m
                                                    .copyWith(
                                                        color: select
                                                            ? AppColor.red1
                                                            : AppColor.gray9),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.saveRecord(item.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.red1,
                        borderRadius: BorderRadius.circular(20.rpx),
                      ),
                      width: 200.rpx,
                      height: 40.rpx,
                      margin: EdgeInsets.only(top: 10.rpx),
                      child: Center(
                        child: Text(
                          "确定求愿",
                          style:
                              AppTextStyle.fs16m.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
