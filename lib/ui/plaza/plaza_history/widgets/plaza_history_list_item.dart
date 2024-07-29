import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';

import '../../../../common/network/api/model/talk_model.dart';
import '../plaza_history_controller.dart';

///浏览历史item
///浏览历史item
class PlazaHistoryListItem extends StatelessWidget {
  final PlazaListModel item;
  final PlazaListModel? prevItem;
  final VoidCallback? onDelete;
  final Function(bool like)? isLike;//点击点赞
  final Function(bool collect)? isCollect;//点收藏回调

  PlazaHistoryListItem({
    super.key,
    required this.item,
    this.prevItem,
    this.onDelete,
    this.isLike,
    this.isCollect
  });

  ActionPane _buildDeleteActionPane() {
    return ActionPane(
      key: ObjectKey(item),
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      children: [
        CustomSlidableAction(
          onPressed: (_) => onDelete?.call(),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          child: Container(
            width: 60.rpx,
            height: 120.rpx,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFBF3C22),
              borderRadius: BorderRadius.circular(4.rpx),
            ),
            child: Text('删除', style: TextStyle(fontSize: 16.rpx)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget child = Slidable(
      endActionPane: _buildDeleteActionPane(),
      child: PlazaCard(
        item: item,
        isCollect: (collect)=>isCollect?.call(collect),
        isLike: (like)=>isLike?.call(like),
      ),
    );
    if(item.browsingTime != prevItem?.browsingTime){
      child = Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.rpx, bottom: 10.rpx),
            child: Text("${item.browsingTime}", style: TextStyle(
              color: const Color(0xff666666),
              fontSize: 12.rpx,
            )),
          ),
          child,
        ],
      );
    }
    return child;
  }
}
