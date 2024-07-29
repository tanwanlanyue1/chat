import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/ui/home/home_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';

///会话抽屉
class ConversationDrawer extends StatelessWidget {
  ConversationDrawer({super.key});
  late final controller = Get.find<HomeController>();
  final state = Get.find<HomeController>().state;

  //聊天图标 type （1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  Map selectIcon(type){
    switch (type) {
      case 1:
        return {
          "name":"周易占卜",
          "icon":"assets/images/home/sinology.png",
        };
      case 2:
        return {
          "name":"塔罗牌占卜",
          "icon":"assets/images/home/tarot_icon.png",
        };
      case 3:
        return {
          "name":"取名",
          "icon":"assets/images/home/take_name_icon.png",
        };
      case 4:
        return {
          "name":"星座-运势",
          "icon":"assets/images/home/star.png",
        };
      case 5:
        return {
          "name":"星座-星盘",
          "icon":"assets/images/home/astrolabe.png",
        };
      case 6:
        return {
          "name":"星座-配对",
          "icon":"assets/images/home/pair_icon.png",
        };
      case 7:
        return {
          "name":"运势",
          "icon":"assets/images/home/fortune_icon.png",
        };
      case 8:
        return {
          "name":"解梦",
          "icon":"assets/images/home/oneiromancy_icon.png",
        };
      default:
        return {
          "name":"疑问",
          "icon":"assets/images/home/issue.png",
        };
    }
  }

  void requestRefresh(){
    Future.delayed(const Duration(milliseconds: 800),(){
      controller.fetchPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    requestRefresh();
    final paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      width: 310.rpx,
      color: const Color(0xffF9F9F9),
      padding: EdgeInsets.only(bottom: 12.rpx),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 49.rpx + paddingTop,
            padding: EdgeInsets.only(left: 12.rpx, top: paddingTop),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("我的问答对话",style: TextStyle(fontSize: 18.rpx,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<HistoryModel>(
                    pagingController: controller.pagingController,
                    itemBuilder: (_,item,index){
                      return Container(
                        margin: EdgeInsets.only(top: 11.rpx,left: 12.rpx,right: 12.rpx),
                        child: Slidable(
                          endActionPane: _buildDeleteActionPane(
                              onDelete: (){
                                controller.removeData(item);
                              }
                          ),
                          child: GestureDetector(
                            onTap: (){
                              controller.getLogDetail(item: item);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.rpx)
                              ),
                              height: 40.rpx,
                              padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImage.asset(
                                    selectIcon(item.type)['icon'],
                                    width: 24.rpx,
                                    height: 24.rpx,
                                  ),
                                  SizedBox(width: 7.rpx,),
                                  Expanded(
                                    child: (jsonDecode(item.parameter ?? '')['question']?.length == 0 || jsonDecode(item.parameter ?? '')['question'] == null) ?
                                    Text(selectIcon(item.type)['name'],style: TextStyle(fontSize: 14.rpx)):
                                    Text("${jsonDecode(item.parameter ?? '')['question']}",style: TextStyle(fontSize: 14.rpx),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                  Text("${item.createTime}",style: TextStyle(fontSize: 12.rpx,color: Color(0xff999999))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              )
            ),
          ),
        ],
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
