import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/ui/disambiguation/disambiguation_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/marquee_view.dart';

import '../../../common/network/api/api.dart';

///标签头部
///title : 标题
class DisambiguationFromTitle extends StatelessWidget {
  final String title;
  final String? icon;
  final bool? vip;
  final Function? callback;
  final List<AdvertisingStartupModel>? carousel;
  DisambiguationFromTitle({super.key, required this.title, this.icon, this.vip, this.callback,this.carousel});

  final disambiguationState = Get.find<DisambiguationController>().state;

  String titles(List<AdvertisingStartupModel>? title){
    String str = ' ';
    for (var element in title ?? []) {
      str += element.title ?? '';
    }
    return str;
  }


  //广告跳转
  onTapAdvertising(){
    if(carousel?[0].gotoType == 1){
      AppLink.jump(carousel?[0].gotoUrl ?? '');
    }else if(carousel?[0].gotoType == 2){
      AppLink.jump(carousel?[0].gotoUrl ?? '',args: jsonDecode(carousel?[0].gotoParam ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.rpx,left: 14.rpx,right: 14.rpx,bottom: 16.rpx),
      child: Row(
        children: [
          AppImage.asset(
            "assets/images/disambiguation/issue.png",
            width: 24.rpx,
            height: 24.rpx,
          ),
          SizedBox(width: 4.rpx,),
          Text(title,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.rpx,
              color: AppColor.gray5
          ),),
          (carousel?.isNotEmpty ?? false) ?
          Expanded(
            child: GestureDetector(
              onTap: onTapAdvertising,
              child: Container(
                  height: 24.rpx,
                  margin: EdgeInsets.only(left: 12.rpx,right: 24.rpx),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/disambiguation/broadcast.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 20.rpx),
                  child: MarqueeView(
                    text: titles(carousel),
                    style: AppTextStyle.fs12m.copyWith(color: AppColor.brown21),
                  )
              ),
            ),
          ):
          Container()
        ],
      ),
    );
  }
}
