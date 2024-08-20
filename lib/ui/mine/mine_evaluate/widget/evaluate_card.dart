import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../../common/network/api/api.dart';

//评价项
//team:团队评价
//goodGirl: 佳丽
class EvaluateCard extends StatelessWidget {
  int index;
  bool team;
  bool goodGirl;
  EvaluationItemModel item;
  EdgeInsetsGeometry? margin;
  EvaluateCard({super.key,required this.index,required this.item,this.margin,this.team = false,this.goodGirl = false});

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
                team ? item.toImg : item.fromImg,
                shape: BoxShape.circle,
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
                            child: Text(team ? item.toName : item.fromName,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,fontWeight: FontWeight.w500),),
                          ),
                          Text(CommonUtils.getPostTime(time: item.createTime,),style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: goodGirl,
                            child: Padding(
                              padding: EdgeInsets.only(right: 4.rpx),
                              child: Text(S.current.synthesize,style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
                            ),
                          ),
                          ...List.generate(5, (i) => AppImage.asset(
                            width: 16.rpx,
                            height: 16.rpx,
                            i < item.star ?
                            'assets/images/mine/star.png':
                            'assets/images/mine/star_none.png',
                          ))
                        ],
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
                    fontSize: 14.rpx,
                    color: AppColor.gray9,
                  ),
                  children: [
                    TextSpan(
                      text: "【${item.fromName}】",
                      style: const TextStyle(
                        color: AppColor.gray30,
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
