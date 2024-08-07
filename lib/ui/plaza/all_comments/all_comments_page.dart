import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'all_comments_controller.dart';

///全部评论
class AllCommentsPage extends StatelessWidget {
  AllCommentsPage({Key? key}) : super(key: key);

  final controller = Get.put(AllCommentsController());
  final state = Get.find<AllCommentsController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          appBar(),
          commentItem(),
        ],
      ),
    );
  }

  Widget appBar(){
    return Container(
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
      color: Colors.white,
      height: 44.rpx+Get.mediaQuery.padding.top,
      margin: EdgeInsets.only(bottom: 8.rpx),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: AppImage.asset(
              width: 64,
              height: 24,
              'assets/images/common/back_black.png',
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8.rpx),
            child: AppImage.asset("assets/images/mine/head_photo.png",width: 36.rpx,height: 36.rpx,),
          ),
          Expanded(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 140.rpx),
                  child: Text("Alma Washington",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                ),
                SizedBox(width: 4.rpx),
                Visibility(
                  replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                  child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                ),
                SizedBox(width: 2.rpx),
                Text("35",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColor.textPurple,
                borderRadius: BorderRadius.circular(20.rpx)
            ),
            width: 60.rpx,
            height: 32.rpx,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 16.rpx),
            child: Text("关注",style: AppTextStyle.fs14b.copyWith(color: Colors.white),),
          )
        ],
      ),
    );
  }

  //评论项
  Widget commentItem(){
    return Container(
      color: Colors.white,
      height: 98.rpx,
      padding: EdgeInsets.all(16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8.rpx),
                child: AppImage.asset("assets/images/mine/head_photo.png",width: 40.rpx,height: 40.rpx,),
              ),
              SizedBox(
                height: 40.rpx,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Alma Washington",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    Row(
                      children: [
                        Visibility(
                          replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                        ),
                        SizedBox(width: 8.rpx),
                        Text("35",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(" 09:35",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
            ],
          ),
          Text("小姐姐，晚上可以约吗？",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        ],
      ),
    );
  }
}
