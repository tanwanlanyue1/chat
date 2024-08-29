import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import '../dating_hall/dating_hall_controller.dart';

//筛选弹窗
class FiltrateBottomSheet extends StatelessWidget {
  Function? callBack;
  FiltrateBottomSheet({super.key,this.callBack});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RectifyTheWorkplaceController>(
      id: 'bottomSheet',
      builder: (controller){
        var state = controller.state;
        return Container(
          padding: EdgeInsets.all(16.rpx).copyWith(bottom: Get.mediaQuery.padding.bottom+16.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.rpx),
              topRight: Radius.circular(14.rpx),
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
                  child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                ),
              ),
              Text("想看",style: AppTextStyle.fs18m.copyWith(color: AppColor.blackBlue,fontWeight: FontWeight.w700),),
              SizedBox(height: 16.rpx),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(state.filtrateType.length, (index) => GestureDetector(
                  onTap: (){
                    if(state.filtrateIndex == index+1){
                      state.filtrateIndex = -1;
                    }else{
                      state.filtrateIndex = index+1;
                    }
                    controller.additionLabel();
                  },
                  child: Column(
                    children: [
                      AppImage.asset(state.filtrateIndex == index+1 ? state.filtrateType[index]['activeImage']:state.filtrateType[index]['image'],width: 60.rpx,height: 60.rpx,),
                      Text(state.filtrateType[index]['name'],style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                    child: Text("年龄",style: AppTextStyle.fs18m.copyWith(color: AppColor.blackBlue,fontWeight: FontWeight.w700),),
                  ),
                  Obx(() => Container(
                    margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                    child: Text("${state.info?.value.likeAgeMin}-${state.info?.value.likeAgeMax}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w700),),
                  )),
                ],
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Obx(() => RangeSlider(
                    values: RangeValues(
                      state.info?.value.likeAgeMin.toDouble() ?? 20.0,
                      state.info?.value.likeAgeMax.toDouble() ?? 40.0,
                    ),
                    min: state.ageMin.toDouble(),
                    max: state.ageMax.toDouble(),
                    onChanged: (value) {
                      controller.onChangeLikeAge(
                          value.start.toInt(), value.end.toInt());
                    },
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.ageMin.toString(),
                        style: AppTextStyle.fs14m.copyWith(color: AppColor.black9),
                      ),
                      Text(
                          state.ageMax.toString(),
                          style: AppTextStyle.fs14m.copyWith(color: AppColor.black9)
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                child: Text("偏爱的风格",style: AppTextStyle.fs18m.copyWith(color: AppColor.blackBlue,fontWeight: FontWeight.w700),),
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
                  return GestureDetector(
                    onTap: () => controller.setLabel(index),
                    child: Container(
                      decoration: BoxDecoration(
                          color: state.labelList.contains(index) ? AppColor.gradientBegin : Colors.white,
                          border: Border.all(color: AppColor.gradientBegin),
                          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                      ),
                      alignment: Alignment.center,
                      child: Text(item.tag,style: AppTextStyle.fs14b.copyWith(color: state.labelList.contains(index) ? Colors.white : AppColor.gradientBegin),),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.rpx,),
              CommonGradientButton(
                height: 50.rpx,
                text: S.current.confirm,
                onTap: (){
                  callBack?.call();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
