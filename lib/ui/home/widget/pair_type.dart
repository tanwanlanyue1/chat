
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/star.dart';

///星座-配对
class PairType extends StatelessWidget {
  Map item;
  PairType({super.key, required this.item});

  Map? starType(String name){
    for (var element in Star.starSignList) {
      if(name.contains(element.name!)){
        return {
          "time": element.time,
          "name": element.name,
          "icon": element.icon,
        };
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    starPair():
    history();
  }

  //星座-配对
  Widget starPair(){
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gray20,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 1.rpx,right: 22.rpx),
      padding: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx,left: 12.rpx),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                height: 66.rpx,
                // width: 140.rpx,
                margin: EdgeInsets.only(right: 24.rpx),
                padding: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 40.rpx,
                          height: 40.rpx,
                          margin: EdgeInsets.only(right: 8.rpx,top: 6.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.gray91,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          alignment: Alignment.center,
                          child: AppImage.asset(item['quiz']['man'].icon,width: 30.rpx,height: 30.rpx,),
                        ),
                        Positioned(
                          right: 0,
                          child: AppImage.asset('assets/images/disambiguation/man.png',width: 16.rpx,height: 16.rpx,),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['quiz']['man'].name,style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
                        Text(item['quiz']['man'].time,style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                height: 66.rpx,
                margin: EdgeInsets.only(right: 12.rpx),
                padding: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 40.rpx,
                          height: 40.rpx,
                          margin: EdgeInsets.only(right: 8.rpx,top: 6.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.gray91,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          alignment: Alignment.center,
                          child: AppImage.asset(item['quiz']['woman'].icon,width: 30.rpx,height: 30.rpx,),
                        ),
                        Positioned(
                          right: 0,
                          child: AppImage.asset('assets/images/disambiguation/girl.png',width: 16.rpx,height: 16.rpx,),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['quiz']['woman'].name,style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
                        Text(item['quiz']['woman'].time,style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 14.rpx,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 43.rpx,
                height: 21.rpx,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.gray91,
                    border: Border.all(width: 1.rpx,color: AppColor.primary),
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                child: Text("配对",style: AppTextStyle.fs13b.copyWith(color: AppColor.primary,height: 1),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //历史
  Widget history() {
    var parameter = jsonDecode(item['parameter']);
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gray20,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 1.rpx,right: 22.rpx),
      padding: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx,left: 12.rpx),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                height: 66.rpx,
                // width: 140.rpx,
                margin: EdgeInsets.only(right: 24.rpx),
                padding: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 40.rpx,
                          height: 40.rpx,
                          margin: EdgeInsets.only(right: 8.rpx,top: 6.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.gray91,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          alignment: Alignment.center,
                          child: AppImage.asset(starType(parameter['man'])?['icon'],width: 30.rpx,height: 30.rpx,),
                        ),
                        Positioned(
                          right: 0,
                          child: AppImage.asset('assets/images/disambiguation/man.png',width: 16.rpx,height: 16.rpx,),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(starType(parameter['man'])?['name'],style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
                        Text(starType(parameter['man'])?['time'],style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                height: 66.rpx,
                margin: EdgeInsets.only(right: 12.rpx),
                padding: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 40.rpx,
                          height: 40.rpx,
                          margin: EdgeInsets.only(right: 8.rpx,top: 6.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.gray91,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          alignment: Alignment.center,
                          child: AppImage.asset(starType(parameter['woman'])?['icon'],width: 30.rpx,height: 30.rpx,),
                        ),
                        Positioned(
                          right: 0,
                          child: AppImage.asset('assets/images/disambiguation/girl.png',width: 16.rpx,height: 16.rpx,),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(starType(parameter['woman'])?['name'],style: AppTextStyle.fs14m.copyWith(color: AppColor.brown26),),
                        Text(starType(parameter['woman'])?['time'],style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 14.rpx,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 43.rpx,
                height: 21.rpx,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.gray91,
                    border: Border.all(width: 1.rpx,color: AppColor.primary),
                    borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                ),
                child: Text("配对",style: AppTextStyle.fs13b.copyWith(color: AppColor.primary,height: 1),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
