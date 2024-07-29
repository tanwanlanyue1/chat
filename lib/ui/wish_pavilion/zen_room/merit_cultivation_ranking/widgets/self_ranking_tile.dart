import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/merit_ranking/merit_ranking_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class SelfRankingTile extends StatelessWidget {
  final CultivationRankingModel item;
  final String unit;

  const SelfRankingTile({
    super.key,
    required this.item,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: FEdgeInsets(
            horizontal: 30.rpx,
            top: 12.rpx,
            bottom: max(12.rpx, MediaQuery.of(context).padding.bottom),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.rpx)),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEF5DA), Color(0xFFFFFAF0)],
              )),
          child: Row(
            children: [
              buildRank(),
              buildAvatar(),
              Expanded(
                  child: Text(
                item.name,
                style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
              )),
              Text(
                '${item.number}$unit',
                style: AppTextStyle.fs18b.copyWith(color: AppColor.red1),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: buildFlag(),
        ),
      ],
    );
  }

  Widget buildFlag() {
    return Container(
      width: 47.rpx,
      height: 16.rpx,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.rpx),
          bottomLeft: Radius.circular(12.rpx),
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0x668D310F),
            Color(0x8F8D310F),
            Color(0x668D310F),
          ],
        ),
      ),
      child: Text(
        '自己',
        style: AppTextStyle.fs10m.copyWith(color: Colors.white),
      ),
    );
  }

  Widget buildRank() {
    return Text(
      item.ranking.toString(),
      style: TextStyle(
        fontSize: 24.rpx,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFD48651),
      ),
    );
  }

  Widget buildAvatar() {
    return Container(
      width: 36.rpx,
      height: 36.rpx,
      margin: FEdgeInsets(left: 30.rpx, right: 8.rpx),
      child: ClipOval(
        child: AppImage.network(
          item.avatar,
          fit: BoxFit.cover,
          width: 36.rpx,
          height: 36.rpx,
        ),
      ),
    );
  }
}
