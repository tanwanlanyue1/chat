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
  const FiltrateBottomSheet({super.key});

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
              Container(
                alignment: Alignment.centerRight,
                child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
              ),
              Text("想看",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w700),),
              SizedBox(height: 16.rpx),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(state.filtrateType.length, (index) => GestureDetector(
                  onTap: (){
                    state.filtrateIndex = index;
                    controller.update(['bottomSheet']);
                  },
                  child: Column(
                    children: [
                      AppImage.asset(state.filtrateIndex == index ? state.filtrateType[index]['activeImage']:state.filtrateType[index]['image'],width: 60.rpx,height: 60.rpx,),
                      Text(state.filtrateType[index]['name'],style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                child: Text("年龄",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w700),),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  RangeSlider(
                    values: RangeValues(
                      18,24
                      // info.likeAgeMin.toDouble(),
                      // info.likeAgeMax.toDouble(),
                    ),
                    min: 16,
                    max: 45,
                    onChanged: (value) {
                      // controller.onChangeLikeAge(
                      //     value.start.toInt(), value.end.toInt());
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "16",
                        // state.ageMin.toString(),
                        style: AppTextStyle.fs14m.copyWith(color: AppColor.black9),
                      ),
                      Text(
                        "24",
        // state.ageMax.toString()
                          style: AppTextStyle.fs14m.copyWith(color: AppColor.black9)
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
                child: Text("偏爱的风格",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w700),),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.rpx,
                    mainAxisSpacing: 12.rpx,
                    mainAxisExtent: 46.rpx
                ),
                itemCount: state.styleList.length,
                itemBuilder: (_, index) {
                  var item = state.styleList[index];
                  return GestureDetector(
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.rpx),
                          border: Border.all(width: 1.rpx, color: AppColor.primary),
                        ),
                        child: Text(item,style: AppTextStyle.fs14m,)),
                    onTap: (){},
                  );
                },
              ),
              SizedBox(height: 24.rpx,),
              CommonGradientButton(
                height: 50.rpx,
                text: S.current.confirm,
              )
            ],
          ),
        );
      },
    );
  }
}
