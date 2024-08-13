import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

import '../../../common/network/api/api.dart';

///客户项
class ClientCard extends StatelessWidget {
  final UserModel? item;
  final String? visitTime;
  final VoidCallback? onTap;
  const ClientCard({super.key, this.onTap,this.item,this.visitTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.rpx,right: 14.rpx,top: 24.rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8.rpx),
                child: AppImage.network(item?.avatar ?? '',width: 40.rpx,height: 40.rpx,),
              ),
              Expanded(
                child: SizedBox(
                  height: 40.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8.rpx),
                            constraints: BoxConstraints(
                                maxWidth: Get.width-200.rpx
                            ),
                            child: Text(item!.nickname,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                          AppImage.asset("assets/images/mine/safety.png",width: 16.rpx,height: 16.rpx,),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: item!.gender.isFemale,
                            replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                            child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                          ),
                          SizedBox(width: 8.rpx),
                          Text('${item?.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                          Container(
                            width: 4.rpx,
                            height: 4.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                            decoration: const BoxDecoration(
                              color: AppColor.black6,
                              shape: BoxShape.circle,
                            ),
                          ),
                          visitTime == null ?
                          Text(
                            item!.type.label,
                            style: AppTextStyle.fs12m
                                .copyWith(color: AppColor.gray30),
                          ) :
                          Text("${CommonUtils.getPostTime(time: visitTime,)}",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Button.stadium(
                onPressed: onTap,
                width: 82.rpx,
                height: 28.rpx,
                backgroundColor: item!.gender.isFemale ? AppColor.purple6 : AppColor.textBlue,
                child: Text(S.current.getTouchWith,style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
              )
            ],
          ),
          Container(
            height: 1.rpx,
            alignment: Alignment.center,
            color: AppColor.scaffoldBackground,
            margin: EdgeInsets.only(top: 24.rpx),
          ),
        ],
      ),
    );
  }
}

extension on UserType {
  String get label{
    switch(this){
      case UserType.user:
        return '个人';
      case UserType.beauty:
        return '佳丽';
      case UserType.agent:
        return '经纪人';
    }
  }
}
