import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';

///用户风格列表
///all:展示全部
class UserStyle extends StatelessWidget {
  final List<LabelModel>? styleList;
  final bool all;

  const UserStyle({super.key, required this.styleList,this.all = false});
  final double skewX = 0.1;

  @override
  Widget build(BuildContext context) {
    return styleList != null && styleList!.isNotEmpty?
    ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(all ? styleList!.length : (styleList!.length > 3 ? 3 :styleList!.length), (index) => item(styleList![index])),
    ):
    (SS.appConfig.configRx()?.defaultStyle != null ?
    ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(1, (index) => item(SS.appConfig.configRx()!.defaultStyle!)),
    ) :
    const SizedBox());
  }

  Widget item(LabelModel styleList){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.rpx,vertical: 2.rpx).copyWith(right: 6.rpx),
      transform: Matrix4.skewX(-skewX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.rpx),
        color: AppColor.orange6.withOpacity(0.1),
      ),
      margin: EdgeInsets.only(right: 4.rpx),
      child: Transform(
        transform: Matrix4.skewX(skewX),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage.network(styleList.icon, width: 16.rpx,height: 16.rpx,),
            Padding(
              padding: FEdgeInsets(left: 1.rpx),
              child: Text(
                styleList.tag,
                style: AppTextStyle.fs10m.copyWith(color: AppColor.black20, height: 1,fontSize: 11.rpx),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
