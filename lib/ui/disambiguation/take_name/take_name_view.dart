import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_form_title.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_radio.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_row_item.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'take_name_controller.dart';

///取名
class TakeNameView extends StatelessWidget {
  TakeNameView({super.key});

  late final controller = Get.put(TakeNameController());
  late final state = Get
      .find<TakeNameController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TakeNameController>(
      init: TakeNameController(),
      builder: (_){
        return Column(
          children: [
            DisambiguationFromTitle(title: "我想取名",carousel: state.carousel),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.brown2,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 20.rpx),
                margin: EdgeInsets.only(left: 12.rpx, right: 12.rpx,bottom: 20.rpx),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 36.rpx,
                              margin: EdgeInsets.only(bottom: 20.rpx,),
                              child: DisambiguationRowItem(
                                title: "出生状态:",
                                titleColor: AppColor.brown36,
                                child: DisambiguationRadio(
                                    isSelect: state.beBorn,
                                    title: "已出生",
                                    titleFalse: "未出生",
                                    selectColor: AppColor.brown36,
                                    unselectColor: AppColor.gray9,
                                    titleCall: (bool? val){
                                      controller.setBeBorn = val ?? false;
                                    }
                                ),
                              ),
                            ),
                            Visibility(
                              visible: state.beBorn,
                              child: Container(
                                height: 36.rpx,
                                margin: EdgeInsets.only(bottom: 10.rpx),
                                child: DisambiguationRowItem(
                                  title: "性        别:",
                                  titleColor: AppColor.brown36,
                                  child: DisambiguationRadio(
                                      isSelect: state.sex,
                                      title: "男        ",
                                      titleFalse: "女",
                                      selectColor: AppColor.brown36,
                                      unselectColor: AppColor.gray9,
                                      titleCall: (bool? val){
                                        controller.setSex = val ?? false;
                                      }
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20.rpx,),
                              child: DisambiguationRowItem(
                                title: "姓       氏:",
                                height: 36.rpx,
                                titleColor: AppColor.brown36,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.brown14,
                                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                                    border: Border.all(width: 1.rpx,color: AppColor.brown34),
                                  ),
                                  child: InputWidget(
                                    hintText: '填写取名姓氏',
                                    inputController: controller.familyNameController,
                                    fillColor: const Color(0xffF5F1E9),
                                    textAlign: TextAlign.center,
                                    focusNode: controller.chatFocusNode,
                                    hintStyle: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.rpx),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: state.beBorn,
                              child: GestureDetector(
                                onTap: controller.onTapChooseBirth,
                                child: DisambiguationRowItem(
                                  title: "出生时辰:",
                                  titleColor: AppColor.brown36,
                                  child: Container(
                                    height: 36.rpx,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColor.brown14,
                                      borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                                      border: Border.all(width: 1.rpx,color: AppColor.brown34),
                                    ),
                                    child: Text(state.birthday,style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
