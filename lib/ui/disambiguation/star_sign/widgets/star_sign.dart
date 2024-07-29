import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_controller.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';


class StarSign extends StatelessWidget {
  bool left;
  Function(Starts)? callBack;
  StarSign({super.key,this.callBack,this.left = true});
  final state = Get.find<StarSignController>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
      child: ObxValue((dataRx) {
        int starIndex = dataRx.value;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16.rpx,
            crossAxisSpacing: 16.rpx,
          ),
          padding: EdgeInsets.zero,
          itemCount: state.starSignList.length,
          itemBuilder: (_, index) {
            var item = state.starSignList[index];
            return GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 70.rpx,
                    height: 70.rpx,
                    padding: EdgeInsets.only(top: 4.rpx, left: left ? 4.rpx : 0,bottom: 4.rpx),
                    decoration: BoxDecoration(
                        color: const Color(0xffF5F1E9),
                        border: Border.all(
                            width: 1.5.rpx,
                            color: starIndex == index ? AppColor.red1 : Colors.transparent,
                            style: starIndex == index
                                ? BorderStyle.solid
                                : BorderStyle.none
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                    ),
                    child: Column(
                      crossAxisAlignment: left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppImage.asset(
                          "${item.icon}",
                          width: 20.rpx,
                          height: 20.rpx,
                        ),
                        Text("${item.name}",
                          style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                        Text("${item.time}",
                          style: TextStyle(fontSize: 10.rpx,
                              color: const Color(0xff999999),fontFamily: ''),),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: starIndex == index ?
                    AppImage.asset(
                      "assets/images/disambiguation/select.png",
                      width: 22.rpx,
                      height: 22.rpx,
                    ):Container(),
                  )
                ],
              ),
              onTap: () {
                state.starIndex.value = index;
                callBack?.call(item);
              },
            );
          },
        );
      }, state.starIndex),
    );
  }
}
