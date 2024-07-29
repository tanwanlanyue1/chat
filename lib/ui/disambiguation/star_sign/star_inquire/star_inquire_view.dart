import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/widgets/archives_bottom_sheet.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_radio.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_row_item.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'star_inquire_controller.dart';

///星盘查询
class StarInquireView extends StatelessWidget {
  //出生时间
  Function(List<String> time)? callBack;
  //地址
  Function(Map address)? addressBack;
  StarInquireView({Key? key,this.callBack,this.addressBack}) : super(key: key);

  final controller = Get.put(StarInquireController());
  final state = Get
      .find<StarInquireController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StarInquireController>(builder: (controller) {
      return Container(
        padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx,top: 20.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  unselectColor: const Color(0xff999999),
                  titleCall: (bool? val) {
                    controller.setSex = val ?? false;
                  }
              ),
            ),
            SizedBox(height: 10.rpx,),
            GestureDetector(
              onTap: (){
                controller.onTapChooseBirth().then((val)=>{
                  if(val == true){
                    callBack?.call(state.birthdayList),
                  }
                });
              },
              child: DisambiguationRowItem(
                title: "出生时间:",
                titleColor: AppColor.brown36,
                child: Container(
                  height: 36.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.brown14,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                    border: Border.all(width: 1.rpx,color: AppColor.brown34),
                  ),
                  padding: EdgeInsets.only(right: 8.rpx),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(state.birthday,style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),textAlign: TextAlign.center,),
                      ),
                      AppImage.asset(
                        "assets/images/disambiguation/down.png",
                        width: 16.rpx,
                        height: 16.rpx,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 18.rpx,),
            GestureDetector(
              child: DisambiguationRowItem(
                title: "现居地点:",
                titleColor: AppColor.brown36,
                child: Container(
                  height: 36.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.brown14,
                    borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                    border: Border.all(width: 1.rpx,color: AppColor.brown34),
                  ),
                  padding: EdgeInsets.only(right: 8.rpx),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("${state.allAddressPresent['presentAddress']}",style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),textAlign: TextAlign.center,),
                      ),
                      AppImage.asset(
                        "assets/images/disambiguation/down.png",
                        width: 16.rpx,
                        height: 16.rpx,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Pickers.showAddressPicker(
                  context,
                  initProvince: "${state.allAddressPresent['province']}",
                  initCity: "${state.allAddressPresent['city']}",
                  initTown: "${state.allAddressPresent['town']}",
                  addAllItem: false,
                  onConfirm: (p, c, t) {
                    state.allAddressPresent['presentAddress'] = "$p$c$t";
                    state.allAddressPresent['province'] = p;
                    state.allAddressPresent['city'] = c;
                    state.allAddressPresent['town'] = "$t";
                    addressBack?.call(state.allAddressPresent);
                    controller.update();
                  },
                  pickerStyle: PickerStyle(
                    title: Center(
                      child: Text(
                        "选择地址",
                        style: AppTextStyle.fs16b.copyWith(color: AppColor.red1),
                      ),
                    ),
                    pickerTitleHeight: 65.rpx,
                    commitButton: Padding(
                      padding: EdgeInsets.only(right: 12.rpx),
                      child: Text(
                        "完成",
                        style: TextStyle(
                            fontSize: 14.rpx, color: const Color(0xff8D310F)),
                      ),
                    ),
                    cancelButton: Padding(
                      padding: EdgeInsets.only(left: 12.rpx),
                      child: AppImage.asset(
                        "assets/images/disambiguation/close.png",
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ),
                    headDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            ExamineButton(
              costGold: state.costGold != 0 ? state.costGold : 0,
              callBack: (){
                controller.horoscope();
              },
            )
          ],
        ),
      );
    });
  }
}
