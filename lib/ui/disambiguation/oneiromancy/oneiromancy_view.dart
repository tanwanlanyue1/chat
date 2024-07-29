import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_form_title.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_radio.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_row_item.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'oneiromancy_controller.dart';

///解梦
class OneiromancyView extends StatelessWidget {
  OneiromancyView({Key? key}) : super(key: key);

  late final controller = Get.put(OneiromancyController());
  late final state = Get.find<OneiromancyController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OneiromancyController>(
      init: OneiromancyController(),
      builder: (_){
        return SystemUI.light(
          child: Column(
            children: [
              DisambiguationFromTitle(
                  title: "做了个梦",
                  carousel: state.carousel
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.brown2,
                      borderRadius: BorderRadius.all(Radius.circular(12.rpx))
                  ),
                  padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx, top: 12.rpx),
                  margin: EdgeInsets.only(left: 12.rpx, right: 12.rpx,bottom: 20.rpx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DisambiguationRowItem(
                              title: "性        别:",
                              titleColor: AppColor.brown36,
                              child: DisambiguationRadio(
                                  isSelect: state.sex,
                                  title: "男",
                                  titleFalse: "女",
                                  selectColor: AppColor.brown36,
                                  unselectColor: const Color(0xff999999),
                                  titleCall: (bool? val) {
                                    controller.setSex = val ?? false;
                                  }
                              ),
                            ),
                            Text("梦境描述:",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                            Container(
                              margin: EdgeInsets.only(top: 10.rpx),
                              padding: EdgeInsets.only(top: 6.rpx,right: 4.rpx,bottom: 4.rpx),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF5F1E9),
                                  borderRadius: BorderRadius.circular(8.rpx)
                              ),
                              child: InputWidget(
                                hintText: '请详细填写描述你的梦境内容，描述越详细解答更准确哦~',
                                lines: 5,
                                fillColor: AppColor.brown14,
                                inputController: controller.dreamController,
                                hintStyle: AppTextStyle.fs14m.copyWith(color: AppColor.brown36),
                                maxLength: 200,
                                border: InputBorder.none,
                                focusNode: controller.chatFocusNode,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !state.focus,
                        child: ExamineButton(
                          costGold: state.costGold != 0 ? state.costGold : 0,
                          callBack: (){
                            controller.getPair();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
