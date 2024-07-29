import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/model/plaza/plaza_list_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'mine_collect_controller.dart';

///我的收藏
class MineCollectPage extends StatelessWidget {
  MineCollectPage({Key? key}) : super(key: key);

  final controller = Get.put(MineCollectController());
  final state = Get.find<MineCollectController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineCollectController>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("我的收藏",style: TextStyle(color: const Color(0xff333333),fontSize: 18.rpx),),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: const [
              // GestureDetector(
              //   onTap: controller.onTapDelete,
              //   child: Container(
              //     margin: EdgeInsets.only(right: 12.rpx),
              //     child: AppImage.asset(
              //       "assets/images/mine/message_session_delete.png",
              //       width: 20.rpx,
              //       height: 20.rpx,
              //     ),
              //   ),
              // )
            ],
          ),
          backgroundColor: const Color(0xffF6F8FE),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.rpx),
              child: SmartRefresher(
                controller: controller.pagingController.refreshController,
                onRefresh: controller.pagingController.onRefresh,
                child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
                      pagingController: controller.pagingController,
                      itemBuilder: (_,item,index){
                        return PlazaCard(
                          item: item,
                          isLike: (like) => controller.getCommentLike(like, index),
                          isCollect: (collect) => controller.removeCollect(index),
                        );
                      }
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
