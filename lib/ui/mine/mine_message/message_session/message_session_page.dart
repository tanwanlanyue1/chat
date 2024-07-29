
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/model/user/message_list.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../widgets/app_image.dart';
import 'Items/message_system_item.dart';
import 'message_session_controller.dart';

class MessageSessionPage extends StatelessWidget {
  MessageSessionPage({Key? key}) : super(key: key);

  final controller = Get.put(MessageSessionController());
  final state = Get.find<MessageSessionController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("系统消息"),
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
                      child: _messageListContainer(item)
                  );
                }
            ),
          )
      ),
    );
  }

  Widget _messageListContainer(MessageList item) {
    return GestureDetector(
      onTap: ()=>controller.onTapSystem(item),
      child: Column(
        children: [
          SizedBox(height: 20.rpx),
          Text(
            item.createTime ?? '',
            style: TextStyle(
              color: const Color(0xFF999999),
              fontWeight: FontWeight.w500,
              fontSize: 14.rpx,
            ),
          ),
          SizedBox(height: 12.rpx),
          MessageSystemItem(item: item),
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
          padding: EdgeInsets.only(top: 50.rpx),
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
