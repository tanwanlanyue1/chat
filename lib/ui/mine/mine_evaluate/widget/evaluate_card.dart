import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

//评价项
class EvaluateCard extends StatelessWidget {
  int index;
  bool team;
  EdgeInsetsGeometry? margin;
  EvaluateCard({super.key,required this.index,this.margin,this.team = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.rpx),
      margin: margin ?? EdgeInsets.only(bottom: 8.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppImage.asset(
                width: 50.rpx,
                height: 50.rpx,
                'assets/images/mine/head_photo.png',
              ),
              SizedBox(width: 8.rpx,),
              Expanded(
                child: SizedBox(
                  height: 50.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Alma Washington",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w500),),
                          Text("2024年12月12日",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (i) => AppImage.asset(
                          width: 16.rpx,
                          height: 16.rpx,
                          i == 4 ?
                          'assets/images/mine/star_none.png':
                          'assets/images/mine/star.png',
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 16.rpx),
              child: Text("非常温柔的小姐姐，一次特别的体验，令人难忘。"*(index+1),style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),)
          ),
          team ?
          Container(
              margin: EdgeInsets.only(top: 12.rpx),
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: "——来自用户",
                  style: TextStyle(
                    fontSize: 12.rpx,
                    color: AppColor.gray30,
                  ),
                  children: const [
                    TextSpan(
                      text: "【放羊的星星】",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
          ) :
          Container(),
        ],
      ),
    );
  }
}
