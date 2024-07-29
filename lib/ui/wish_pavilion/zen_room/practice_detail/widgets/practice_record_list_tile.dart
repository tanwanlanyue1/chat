import 'package:flutter/material.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_record_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import '../../../../../common/app_color.dart';

class PracticeRecordListTile extends StatelessWidget {
  final CultivationRecordModel item;

  const PracticeRecordListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        AppTextStyle.st.medium.size(14.rpx).textColor(AppColor.gray5);
    return Container(
      height: 40.rpx,
      margin: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: Row(
        children: [
          SizedBox(
            width: 38.rpx,
            child: Text(
              item.formatTime,
              style: textStyle.textColor(AppColor.gray9),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              VerticalDivider(
                thickness: 1.rpx,
                color: const Color(0x268D310F),
                width: 29.rpx,
              ),
              CircleAvatar(
                backgroundColor: const Color(0xFF8D310F),
                radius: 2.5.rpx,
              ),
            ],
          ),
          AppImage.asset(
            'assets/images/wish_pavilion/ic_practice_record.png',
            width: 30.rpx,
            height: 30.rpx,
          ),
          Expanded(
            child: Padding(
              padding: FEdgeInsets(left: 8.rpx),
              child: Text(
                item.desc,
                style: textStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension on CultivationRecordModel {
  String get formatTime {
    final values = time.split(':').take(2);
    return values.join(':');
  }

  String get desc{
    switch(type){
      case 'tribute':
      //上香或供礼
        return '[$name] 供养「$bname」';
      case 'direction':
        //念珠
        return name;
      case 'scriptures':
        //木鱼诵经
        return '诵念「$name」';
    }
    return name;
  }
}
