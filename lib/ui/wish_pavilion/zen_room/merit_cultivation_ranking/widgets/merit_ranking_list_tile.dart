import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/merit_ranking/merit_ranking_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class MeritRankingListTile extends StatelessWidget {
  final CultivationRankingModel item;

  ///type 0=功德值排行 1=累计修行天数排行 2=连续修行排行 3=上香 4=供礼 5=敲诵 6=念珠
  final int type;

  const MeritRankingListTile({
    super.key,
    required this.item,
    required this.type,
  });

  String get backgroundImage {
    final images = {
      1: 'assets/images/wish_pavilion/zen_room/merit_list_item1.png',
      2: 'assets/images/wish_pavilion/zen_room/merit_list_item2.png',
      3: 'assets/images/wish_pavilion/zen_room/merit_list_item3.png',
    };
    return images[item.ranking] ??
        'assets/images/wish_pavilion/zen_room/merit_list_item.png';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.userCenterPage, arguments: {
          'userId': item.uid,
        });
      },
      child: Container(
        width: 335.rpx,
        height: 60.rpx,
        padding: FEdgeInsets(horizontal: 12.rpx),
        decoration: BoxDecoration(
            image: DecorationImage(image: AppAssetImage(backgroundImage))),
        child: Row(
          children: [
            buildRank(),
            buildAvatar(),
            buildName(),
            buildNumber(),
          ],
        ),
      ),
    );
  }

  String get desc {
    switch (type) {
      case 1:
        return '已累计修行';
      case 2:
        return '坚持连续修行';
      case 3:
        return '已上香';
      case 4:
        return '供品顶礼';
      case 5:
        return '木鱼诵经';
      case 6:
        return '累计念珠';
    }
    return '';
  }

  String get unit {
    if([1,2].contains(type)){
      return '天';
    }
    if([3,4,5,6].contains(type)){
      return '次';
    }
    return '';
  }

  Widget buildName() {
    Widget child = Text(
      item.name,
      style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
    );
    if (desc.isNotEmpty) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Padding(
            padding: FEdgeInsets(top: 4.rpx),
            child: Text(
              desc,
              style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
            ),
          )
        ],
      );
    }

    return Expanded(child: child);
  }

  Widget buildNumber() {

    Widget child = Text(
      item.number.toString(),
      style: AppTextStyle.fs18b.copyWith(color: AppColor.red1),
    );

    if (unit.isNotEmpty) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
          Padding(
            padding: FEdgeInsets(top: 4.rpx),
            child: Text(
              unit,
              style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
            ),
          )
        ],
      );
    }


    return child;
  }

  Widget buildRank() {
    final images = {
      1: 'assets/images/wish_pavilion/zen_room/merit_list_rank1.png',
      2: 'assets/images/wish_pavilion/zen_room/merit_list_rank2.png',
      3: 'assets/images/wish_pavilion/zen_room/merit_list_rank3.png',
    };
    final img = images[item.ranking] ??
        'assets/images/wish_pavilion/zen_room/merit_list_rank.png';
    return Container(
      width: 40.rpx,
      height: 34.rpx,
      alignment: item.ranking > 3 ? Alignment.center : const Alignment(0, -0.6),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AppAssetImage(img),
          fit: BoxFit.fill,
        ),
      ),
      child: Text(
        item.ranking.toString(),
        style: AppTextStyle.fs14b.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildAvatar() {
    final images = {
      1: 'assets/images/wish_pavilion/zen_room/merit_list_avatar1.png',
      2: 'assets/images/wish_pavilion/zen_room/merit_list_avatar2.png',
      3: 'assets/images/wish_pavilion/zen_room/merit_list_avatar3.png',
    };
    final img = images[item.ranking] ??
        'assets/images/wish_pavilion/zen_room/merit_list_avatar.png';
    return Container(
      width: 42.rpx,
      height: 42.rpx,
      margin: FEdgeInsets(left: 15.rpx, right: 8.rpx),
      alignment: Alignment.center,
      padding: item.ranking <= 3 ? FEdgeInsets(bottom: 2.rpx) : null,
      foregroundDecoration: BoxDecoration(
          image: DecorationImage(
        image: AppAssetImage(img),
        fit: BoxFit.fill,
      )),
      child: ClipOval(
        child: AppImage.network(
          item.avatar,
          fit: BoxFit.cover,
          width: 38.rpx,
          height: 38.rpx,
        ),
      ),
    );
  }
}
