import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/ui/plaza/plaza_detail/plaza_detail_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/network/api/model/talk_model.dart';

///评论列表项
///item:评论项
///user：是否展示用户头
///reply:true，全部评论
class ReviewReply extends StatelessWidget {
  CommentListModel item;
  final bool user;
  final bool reply;
  final void Function({CommentListModel subComment})? callBack;
  ReviewReply({super.key, required this.item, this.user = false, this.reply = false,this.callBack});

  final controller = Get.find<PlazaDetailController>();
  final state = Get.find<PlazaDetailController>().state;

  //截取回复的名字
  String replySub(String comment,{bool name = false}){
    if(name){
      if (comment.startsWith('@')) {
        int index = comment.indexOf(":");
        String result = comment.substring(0, index+1);
        return result;
      }
    }else{
      if (comment.startsWith('@')) {
        int index = comment.indexOf(":");
        String result = comment.substring(index+1);
        return result;
      }else{
        return comment;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(user) controller.clean(item: item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Visibility(
                visible: !user,
                child: Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(
                    item.avatar ?? '',
                    width: 32.rpx,
                    height: 32.rpx,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Text("${item.nickname}",style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              SizedBox(width: 4.rpx,),
              Visibility(
                visible: item.star?.isNotEmpty ?? false,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff8D310F),
                      borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                  ),
                  margin: EdgeInsets.only(right: 6.rpx),
                  padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 2.rpx),
                  child: Text(item.star ?? '',style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1.3),),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xffEEC88A),
                    borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 2.rpx),
                child: Text("Lv.${item.cavLevel ?? 1}",style: TextStyle(fontSize: 10.rpx,color: Colors.white),),
              ),
              Visibility(
                visible: item.uid == state.authorId,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                  ),
                  margin: EdgeInsets.only(left: 4.rpx),
                  padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 2.rpx),
                  child: Text("作者",style: TextStyle(fontSize: 10.rpx,color: const Color(0xff999999),height: 1.2),),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.rpx),
            child: RichText(
              text: TextSpan(
                text: replySub(item.content ?? '',name: true),
                style: TextStyle(
                  color: AppColor.blue3,
                  fontSize: 14.rpx,
                ),
                children: [
                  TextSpan(
                    text: replySub(item.content ?? ''),
                    style: TextStyle(
                      color: const Color(0xff333333),
                      fontSize: 14.rpx,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4.rpx,bottom: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${item.createTime}",style: TextStyle(color: const Color(0xffBBBBBB),fontSize: 10.rpx),),
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 4.rpx),
                  child: AppImage.asset("assets/images/plaza/review.png",width: 16.rpx,height: 16.rpx,),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.rpx),
                  child: Text(' ${item.commentNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                ),
                GestureDetector(
                  onTap: (){
                    callBack?.call();
                  },
                  child: Container(
                    height: 20.rpx,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(right: 6.rpx,left: 10.rpx),
                    child: Row(
                      children: [
                        AppImage.asset((item.isLike ?? false)  ? "assets/images/plaza/liking_out.png":"assets/images/plaza/give_a_like.png",width: 16.rpx,height: 16.rpx,),
                        Container(
                          padding: EdgeInsets.only(top: 4.rpx),
                          child: Text(' ${item.likeNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          !reply && (item.subComment?.length ?? 0) != 0 ?
          Container(
            decoration: BoxDecoration(
              color: AppColor.gray14,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.rpx),
                topRight: Radius.circular(4.rpx),
              ),
            ),
            padding: EdgeInsets.only(top: 6.rpx,left: 8.rpx,right: 8.rpx),
            child: ReviewReply(
              item: item.subComment![0],
              callBack: ({CommentListModel? subComment}) {
                callBack?.call(subComment:item.subComment![0]);
              },
            ),
          ) :
          Container(),
        ],
      ),
    );
  }

}
