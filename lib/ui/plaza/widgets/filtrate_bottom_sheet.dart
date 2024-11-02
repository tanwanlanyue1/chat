import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/range_slider_bar.dart';
import 'package:guanjia/widgets/style_tag_widget.dart';

import '../dating_hall/dating_hall_controller.dart';
import '../dating_hall/dating_hall_state.dart';

//筛选弹窗
class FiltrateBottomSheet extends StatelessWidget {
  Function? callBack;
  FiltrateBottomSheet({super.key,this.callBack});

  int? filtrate;
  late double left;
  late double right;

  Future<void>? setValuer(RectifyTheWorkplaceState state){
    if(filtrate == null){
      filtrate = state.filtrateIndex;
      left = state.info?.value.likeAgeMin.toDouble() ?? 20.0;
      right = state.info?.value.likeAgeMax.toDouble() ?? 40.0;
      state.styleList = state.styleListDefault.toList();
      state.labelList = state.labelListDefault.toList();
      state.labelListSelect = state.labelListDefault.toList();
    }else{
      state.labelList = state.labelListSelect;
      state.styleList = state.styleListSelect.isNotEmpty ? state.styleListDefault : state.styleListSelect;
    }
  }

  void setSureVal(RectifyTheWorkplaceController controller){
    controller.state.filtrateIndex = filtrate;
    controller.onChangeLikeAge(left.toInt(), right.toInt());
    controller.state.styleListDefault = controller.state.styleListSelect;
    controller.state.labelListDefault = controller.state.labelListSelect;
    controller.state.labelList = controller.state.labelListSelect;
    callBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RectifyTheWorkplaceController>(
      id: 'bottomSheet',
      builder: (controller){
        var state = controller.state;
        setValuer(state);
        return Container(
          padding: EdgeInsets.all(16.rpx).copyWith(bottom: Get.mediaQuery.padding.bottom+24.rpx),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.rpx),
              topRight: Radius.circular(12.rpx),
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xffEEF1FB),
                Color(0xffEFF0FB),
                Color(0xffF9F3FA),
                Color(0xffF9F3FA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: AppImage.asset('assets/images/common/close.png',width: 20.rpx,height: 20.rpx,color: AppColor.black92,),
                ),
              ),
              Text("您希望Ta是",style: AppTextStyle.fs20b.copyWith(color: AppColor.blackBlue),),
              SizedBox(height: 16.rpx),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(state.filtrateType.length, (index) => GestureDetector(
                  onTap: (){
                    if(filtrate != index+1){
                      filtrate = state.filtrateType[index]['type'];
                      controller.additionLabel(index: filtrate);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.rpx),
                      border: Border.all(width: 1.rpx,color: AppColor.primaryBlue.withOpacity(filtrate == state.filtrateType[index]['type'] ? 1 : 0.1))
                    ),
                    width: 90.rpx,
                    height: 90.rpx,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage.asset(state.filtrateType[index]['activeImage'],width: index == 2 ? 36.rpx : 40.rpx,height: index == 2 ? 36.rpx : 40.rpx,),
                            if(index == 2)
                            AppImage.asset(state.filtrateType[index]['image'],width: 36.rpx,height: 36.rpx,),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.rpx),
                          child: Text(state.filtrateType[index]['name'],style: AppTextStyle.fs14.copyWith(color: AppColor.black20, height: 1),),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24.rpx,bottom: 24.rpx),
                    child: Text(S.current.userAge,style: AppTextStyle.fs14.copyWith(color: AppColor.black92),),
                  ),
                ],
              ),
              SizedBox(
                height: 32.rpx,
                child: RangeSliderBar(
                  min: state.ageMin.toDouble(),
                  max: state.ageMax.toDouble(),
                  leftValue: left,
                  rightValue: right,
                  onDragging: (leftVal,rightVal){
                    left = leftVal;
                    right = rightVal;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                child: Text(S.current.preferredStyle,style: AppTextStyle.fs14.copyWith(color: AppColor.black92),),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.rpx,
                    mainAxisSpacing: 12.rpx,
                    mainAxisExtent: 42.rpx
                ),
                itemCount: state.styleList.length,
                itemBuilder: (_, index) {
                  var item = state.styleList[index];
                  return StyleTagWidget.filtrate(
                    icon: item.icon,
                    title: item.tag,
                    isSelected: state.labelList.contains(index),
                    onChanged: (value) => controller.setLabel(index),
                  );
                },
              ),
              SizedBox(height: 24.rpx,),
              CommonGradientButton(
                height: 50.rpx,
                text: S.current.confirm,
                onTap: ()=> setSureVal(controller),
              )
            ],
          ),
        );
      },
    );
  }
}
