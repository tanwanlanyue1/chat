import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/ui/mine/mine_message/mine_message_state.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import '../../../../common/network/api/api.dart';
import 'message_notice_controller.dart';

///我的-消息
class MessageNotice extends StatelessWidget {
  MessageNotice({Key? key}) : super(key: key);

  final controller = Get.put(MessageNoticeController());
  final state = Get.find<MessageNoticeController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("通知公告"),
      ),
      body: SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: PagedListView(
            pagingController: controller.pagingController,
            padding: EdgeInsets.all(12.rpx),
            builderDelegate: DefaultPagedChildBuilderDelegate<MessageList>(
                pagingController: controller.pagingController,
                itemBuilder: (_,item,index){
                  return _messageListContainer(item);
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
          SizedBox(height: 10.rpx),
          Text(
            item.systemMessage?.createTime ?? '',
            style: TextStyle(
              color: const Color(0xFF999999),
              fontWeight: FontWeight.w500,
              fontSize: 14.rpx,
            ),
          ),
          SizedBox(height: 12.rpx),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.rpx),
            padding: EdgeInsets.all(12.rpx),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.systemMessage?.title ?? '',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.rpx,
                  ),
                ),
                SizedBox(height: 5.rpx),
                Text(
                  item.systemMessage?.content ?? '',
                  style: TextStyle(
                    color: AppColor.gray9,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.rpx,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
