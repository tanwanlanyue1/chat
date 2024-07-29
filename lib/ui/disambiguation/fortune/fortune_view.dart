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

import 'fortune_controller.dart';

///运势
class FortuneView extends StatelessWidget {
  FortuneView({super.key});

  late final controller = Get.put(FortuneController());
  late final state = Get.find<FortuneController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FortuneController>(
      init: FortuneController(),
      builder: (_){
        return Column(
          children: [
            DisambiguationFromTitle(title: "运势测算", carousel: state.carousel),
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DisambiguationRowItem(
                              title: "性        别:",
                              titleColor: AppColor.brown36,
                              height: 36.rpx,
                              child: DisambiguationRadio(
                                  isSelect: state.sex,
                                  title: "男",
                                  titleFalse: "女",
                                  selectColor: AppColor.brown36,
                                  unselectColor: AppColor.gray9,
                                  titleCall: (bool? val) {
                                    controller.setSex = val ?? false;
                                  }
                              ),
                            ),
                            SizedBox(height: 10.rpx,),
                            DisambiguationRowItem(
                              title: "测算姓名:",
                              titleColor: AppColor.brown36,
                              child: Container(
                                height: 36.rpx,
                                decoration: BoxDecoration(
                                  color: AppColor.brown14,
                                  borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                                  border: Border.all(width: 1.rpx,color: AppColor.brown34),
                                ),
                                child: InputWidget(
                                    hintText: '填写测算姓名',
                                    fillColor: AppColor.brown14,
                                    textAlign: TextAlign.center,
                                    inputController: controller.nameController,
                                    focusNode: controller.chatFocusNode,
                                    hintStyle: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8.rpx)
                                    ),
                                ),
                              ),
                            ),
                            SizedBox(height: 18.rpx),
                            GestureDetector(
                              onTap: controller.onTapChooseBirth,
                              child: DisambiguationRowItem(
                                title: "出生时辰:",
                                titleColor: AppColor.brown36,
                                child: Container(
                                  height: 36.rpx,
                                  decoration: BoxDecoration(
                                    color: AppColor.brown14,
                                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                                    border: Border.all(width: 1.rpx,color: AppColor.brown34),
                                  ),
                                  padding: EdgeInsets.only(right: 8.rpx),
                                  alignment: Alignment.center,
                                  child: Text(state.birthday,style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 24.rpx),
                              child: Row(
                                children: List.generate(
                                    state.calculateType.length, (i) =>
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 12.rpx),
                                          height: 30.rpx,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: state.calculateIndex == i ?
                                                [
                                                  AppColor.red8,
                                                  AppColor.red58
                                                ] :
                                                [
                                                  AppColor.brown2,
                                                  AppColor.brown2
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              border: Border.all(width: 1.rpx,
                                                  color: AppColor.brown34),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.rpx))
                                          ),
                                          child: Text(
                                            "${state.calculateType[i]['name']}",style: AppTextStyle.fs12b.copyWith(color: state.calculateIndex == i ? Colors.white : AppColor.brown36),),),
                                        onTap: () {
                                          controller.setCalculate = i;
                                        },
                                      ),
                                    )),
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
                    ),
                  ],
                ),
              ),
            )
          ],);
      },
    );
  }
}
