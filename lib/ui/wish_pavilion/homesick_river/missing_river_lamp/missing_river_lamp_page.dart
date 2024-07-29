import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';

import '../../../../common/network/api/model/talk_model.dart';
import 'missing_river_lamp_controller.dart';

///思念河灯-弹窗
class MissingRiverLampPage extends StatelessWidget {
  MissingRiverLampPage({Key? key}) : super(key: key);

  late final state = Get.find<MissingRiverLampController>().state;

  static void show({Function()? callback}) {
    Get.bottomSheet(
      isScrollControlled: true,
      MissingRiverLampPage(),
    );
  }

  //更多时效
  void moreAging() {
    Get.dialog(
      Center(
        child: ObxValue(
            (agingCurrent) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.rpx),
                    ),
                  ),
                  width: Get.width * 0.8,
                  height: 310.rpx,
                  padding: EdgeInsets.only(top: 24.rpx),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 40.rpx),
                              child: Text(
                                "选择时效",
                                style: AppTextStyle.fs18b
                                    .copyWith(color: AppColor.red1),
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
                      SizedBox(
                        height: 20.rpx,
                      ),
                      Visibility(
                        visible: state.allTime.isNotEmpty,
                        replacement: Text(
                          '$agingCurrent',
                          style: TextStyle(fontSize: 0.rpx),
                        ),
                        child: Wrap(
                          runSpacing: 8.rpx,
                          spacing: 8.rpx,
                          children: List.generate(state.allTime.length, (i) {
                            return SizedBox(
                              width: 70.rpx,
                              child: buildAging(
                                  item: state.allTime[i],
                                  agingBool: state.agingCurrent.value ==
                                      state.allTime[i].id,
                                  callback: () {
                                    state.agingCurrent.value =
                                        state.allTime[i].id;
                                  }),
                            );
                          }),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.rpx, vertical: 20.rpx),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: 40.rpx,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.5.rpx, color: AppColor.red1),
                                      borderRadius:
                                          BorderRadius.circular(20.rpx)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "取消",
                                    style: AppTextStyle.fs18b
                                        .copyWith(color: AppColor.red1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 24.rpx,
                            ), //state.selectAging
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  for (var element in state.allTime) {
                                    if (element.id == agingCurrent.value) {
                                      state.selectAging.value = element;
                                    }
                                  }
                                  Get.back();
                                },
                                child: Container(
                                  height: 40.rpx,
                                  decoration: BoxDecoration(
                                      color: AppColor.red1,
                                      borderRadius:
                                          BorderRadius.circular(20.rpx)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "确定",
                                    style: AppTextStyle.fs18b
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            state.agingCurrent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissingRiverLampController>(
      id: "MissingRiverLampController",
      init: MissingRiverLampController(),
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
                            "思念河灯",
                            style: AppTextStyle.fs18b.copyWith(color: AppColor.brown26),
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
                    padding: EdgeInsets.all(12.rpx),
                    children: [
                      SizedBox(
                        height: 112.rpx,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                state.river = index;
                                controller.getConfig(acquiesce: 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: state.river == index
                                      ? AppColor.gold7
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                                width: 100.rpx,
                                height: 100.rpx,
                                margin: EdgeInsets.only(
                                    right: 8.rpx, bottom: 12.rpx),
                                child: Center(
                                  child: Container(
                                    height: 92.rpx,
                                    width: 92.rpx,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5.rpx,
                                            color: state.river == index
                                                ? AppColor.gold8
                                                : AppColor.gold7),
                                        borderRadius:
                                            BorderRadius.circular(8.rpx)),
                                    child: AppImage.network(
                                      state.votiveSkyLantern[index].image,
                                      width: 90.rpx,
                                      height: 90.rpx,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: state.votiveSkyLantern.length,
                        ),
                        // child: ,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8.rpx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "左右滑动查看更多  ",
                              style: TextStyle(
                                  color: const Color(0xff666666),
                                  fontSize: 12.rpx),
                            ),
                            AppImage.asset(
                              'assets/images/wish_pavilion/homesick/slide.png',
                              width: 56.rpx,
                              height: 12.rpx,
                            ),
                          ],
                        ),
                      ),
                      state.votiveSkyLantern.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFF1D5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.rpx))),
                              padding: EdgeInsets.only(
                                  top: 4.rpx,
                                  left: 12.rpx,
                                  right: 12.rpx,
                                  bottom: 8.rpx),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "${state.votiveSkyLantern[state.river].name}\n",
                                  style: TextStyle(
                                      color: const Color(0xff8D310F),
                                      fontSize: 16.rpx,
                                      fontWeight: FontWeight.bold,
                                      height: 2),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: state
                                          .votiveSkyLantern[state.river].remark,
                                      style: TextStyle(
                                          color: const Color(0xff8D310F),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.rpx,
                                          height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(top: 12.rpx, bottom: 2.rpx),
                        child: Text(
                          "思念之情：",
                          style: AppTextStyle.fs16b
                              .copyWith(color: AppColor.gray5),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1.rpx, color: AppColor.gray12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.rpx))),
                        padding: EdgeInsets.only(
                            top: 6.rpx, bottom: 8.rpx, right: 6.rpx),
                        margin: EdgeInsets.only(bottom: 8.rpx),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputWidget(
                                hintText: '请写下您的思念或祝福',
                                lines: 5,
                                maxLength: 199,
                                counterText: '',
                                fillColor: Colors.white,
                                inputController: controller.missInputController,
                                onChanged: (val) {
                                  controller
                                      .update(['MissingRiverLampController']);
                                }),
                            Padding(
                              padding: EdgeInsets.all(6.rpx),
                              child: Row(
                                children: [
                                  Text(
                                    " ${controller.missInputController.text.length}/199",
                                    style: AppTextStyle.fs14m
                                        .copyWith(color: AppColor.gray9),
                                  ),
                                  const Spacer(),
                                  state.open == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.setOpen();
                                          },
                                          child: AppImage.asset(
                                            "assets/images/wish_pavilion/homesick/pitch_on.png",
                                            width: 20.rpx,
                                            height: 20.rpx,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            controller.setOpen();
                                          },
                                          child: AppImage.asset(
                                            "assets/images/wish_pavilion/homesick/unselected.png",
                                            width: 20.rpx,
                                            height: 20.rpx,
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.setOpen();
                                    },
                                    child: Text(
                                      " 内容仅自己可见",
                                      style: AppTextStyle.fs14m
                                          .copyWith(color: AppColor.gray30),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: state.selectAging.value == null
                                    ? Row(
                                        children: List.generate(
                                            state.timeLimit.length > 4
                                                ? 4
                                                : state.timeLimit.length,
                                            (index) {
                                          return Padding(
                                            padding: EdgeInsets.only(right: 8.rpx),
                                            child: buildAging(
                                                item: state.timeLimit[index],
                                                agingBool:
                                                state.agingCurrent.value ==
                                                    state.timeLimit[index].id,
                                                callback: () {
                                                  state.agingCurrent.value =
                                                      state.timeLimit[index].id;
                                                }),
                                          );
                                        }),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          buildAging(
                                            item: state.selectAging.value!,
                                            agingBool: true,
                                          )
                                        ],
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller
                                      .getConfig()
                                      .then((value) => moreAging());
                                },
                                child: Container(
                                  width: 39.rpx,
                                  height: 70.rpx,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.rpx, color: AppColor.gray12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.rpx))),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "更\n多\n时\n效",
                                    style: AppTextStyle.fs12b
                                        .copyWith(color: AppColor.gray30),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.saveRecord();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.red1,
                      borderRadius: BorderRadius.circular(20.rpx),
                    ),
                    width: 200.rpx,
                    height: 40.rpx,
                    child: Center(
                      child: Text(
                        "确定",
                        style: AppTextStyle.fs16m.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //时效
  Widget buildAging(
      {Function? callback,
      required bool agingBool,
      required TimeConfigModel item}) {
    return GestureDetector(
      onTap: () {
        callback?.call();
      },
      child: Container(
        width: 70.rpx,
        height: 70.rpx,
        decoration: BoxDecoration(
            color: agingBool ? AppColor.gold7 : Colors.white,
            border: Border.all(
                width: 1.rpx,
                color: agingBool ? AppColor.gold8 : AppColor.gray12),
            borderRadius: BorderRadius.all(Radius.circular(8.rpx))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CommonUtils.getSecond(time: item.periodTime),
              style: AppTextStyle.fs16b
                  .copyWith(color: agingBool ? AppColor.red1 : AppColor.gray30),
            ),
            Visibility(
              visible: item.goldNum != 0,
              replacement: Text(
                "免费",
                style: AppTextStyle.fs14m.copyWith(color: AppColor.green2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage.asset(
                    'assets/images/disambiguation/repair.png',
                    width: 16.rpx,
                    height: 16.rpx,
                  ),
                  Text(
                    " ${item.goldNum ?? 0}",
                    style: AppTextStyle.fs16b.copyWith(
                        color: agingBool ? AppColor.red1 : AppColor.gray30),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: item.goldNum == 0,
              child: Text(
                "(${item.surplusCount}/${item.freeCount})",
                style: AppTextStyle.fs12m.copyWith(
                    color: agingBool ? AppColor.red1 : AppColor.gray30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
