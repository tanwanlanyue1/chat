import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../../common/network/api/api.dart';

//评价项
class EvaluateCard extends StatelessWidget {
  int index;
  bool team;
  bool client;
  EvaluationItemModel item;
  EdgeInsetsGeometry? margin;
  EvaluateCard({super.key,required this.index,required this.item,this.margin,this.client = false,this.team = false});

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
              AppImage.network(
                width: 50.rpx,
                height: 50.rpx,
                client ? item.toImg : item.fromImg,
              ),
              SizedBox(width: 8.rpx,),
              Expanded(
                child: SizedBox(
                  height: 50.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(client ? item.toName : item.fromName,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w500),),
                          ),
                          Text(CommonUtils.getPostTime(time: item.createTime,),style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (i) => AppImage.asset(
                          width: 16.rpx,
                          height: 16.rpx,
                          i == item.star ?
                          'assets/images/mine/star.png':
                          'assets/images/mine/star_none.png',
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
              child: Text(item.content,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),)
          ),
          team ?
          Container(
              margin: EdgeInsets.only(top: 12.rpx),
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: "——${S.current.fromUser}",
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
