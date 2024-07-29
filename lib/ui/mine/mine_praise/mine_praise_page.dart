import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/api.dart';
import '../../../widgets/app_image.dart';
import 'mine_praise_controller.dart';

class MinePraisePage extends StatelessWidget {
  MinePraisePage({Key? key}) : super(key: key);

  final controller = Get.put(MinePraiseController());
  final state = Get.find<MinePraiseController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("赞"),
      ),
      body: SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: PagedListView(
            pagingController: controller.pagingController,
            padding: EdgeInsets.only(top: 12.rpx,left: 12.rpx,right: 12.rpx),
            builderDelegate: DefaultPagedChildBuilderDelegate<MessageList>(
                pagingController: controller.pagingController,
                itemBuilder: (_,item,index){
                  return Slidable(
                    endActionPane: _buildDeleteActionPane(
                        onDelete: (){
                          controller.removeCollect(item.id!,index);
                        }
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"userId":item.post?.uid,"communityId":item.post?.id});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.rpx, horizontal: 8.rpx),
                        margin: EdgeInsets.only(bottom: 12.rpx),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.userInfo?.uid});
                                  },
                                  child: ClipOval(
                                    child: AppImage.network(item.userInfo?.avatar ?? '',
                                        width: 36.rpx, height: 36.rpx),
                                  ),
                                ),
                                SizedBox(width: 8.rpx),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.userInfo?.uid});
                                        },
                                        child: Text(
                                          item.userInfo?.nickname ?? '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: const Color(0xFF333333),
                                            fontSize: 14.rpx,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "${item.createTime}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: const Color(0xFF999999),
                                          fontSize: 12.rpx,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.rpx),
                            Text(
                              item.content ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 14.rpx,
                              ),
                            ),
                            Visibility(
                              visible: item.extraJson?.commentId != null,
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 6.rpx),
                                  child: RichText(
                                    text: TextSpan(
                                      text: SS.login.info?.nickname ?? '',
                                      style: TextStyle(
                                        color: const Color(0xFF77C1FF),
                                        fontSize: 12.rpx,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "：",
                                          style: TextStyle(
                                            color: const Color(0xFF666666),
                                            fontSize: 12.rpx,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.comment?.content ?? '',
                                          style: TextStyle(
                                            color: const Color(0xFF666666),
                                            fontSize: 12.rpx,
                                          ), // 同样，12.rpx依据你的封装进行转换
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Container(
                              color: const Color(0xFFF6F8FE),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.rpx, vertical: 5.rpx),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "主贴  ${item.post?.title ?? ''}",
                                maxLines: 1,
                                style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontSize: 11.rpx,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
      ),
    );
  }

  ActionPane _buildDeleteActionPane({VoidCallback? onDelete}) {
    return ActionPane(
      extentRatio: 0.3,
      motion: const ScrollMotion(),
      children: [
        CustomSlidableAction(
          onPressed: (_) => {
            onDelete?.call()
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          child: Container(
            width: 50.rpx,
            height: 40.rpx,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4.rpx),
            ),
            child: Text('删除', style: TextStyle(fontSize: 14.rpx,color: Colors.white)),
          ),
        )
      ],
    );
  }
}
