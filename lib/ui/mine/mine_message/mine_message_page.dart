import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/ui/mine/mine_message/mine_message_state.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import '../../../widgets/app_image.dart';
import 'mine_message_controller.dart';

///我的-消息
class MineMessagePage extends StatelessWidget {
  MineMessagePage({Key? key}) : super(key: key);

  final controller = Get.put(MineMessageController());
  final state = Get.find<MineMessageController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("消息"),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.fetchPage,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: GetBuilder<MineMessageController>(
              builder: (_){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _optionContainer(),
                    SizedBox(height: 1.rpx),
                    ...List.generate(state.items.length, (index) {
                      var item = state.items[index];
                      return _messageListContainer(item,index);
                    })
                  ],
                );
              })
            ),
          ],
        ),
      ),
    );
  }

  Container _optionContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 12.rpx, right: 12.rpx, top: 14.rpx),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.rpx))),
      child: Wrap(
        spacing: 55.rpx,
        alignment: WrapAlignment.center,
        children: List.generate(state.options.length, (index) {
          var option = state.options[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.onTapOptions(option.route,index),
            child: Container(
              padding: EdgeInsets.all(8.rpx),
              child: Column(
                children: [
                  Badge(
                    offset: Offset(8.rpx, 0),
                    padding: EdgeInsets.symmetric(horizontal: 5.rpx),
                    largeSize: 18.rpx,
                    label: Text(
                      option.unread > 99 ? "+99" : "+${option.unread}",
                      style: TextStyle(
                        fontSize: 12.rpx,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    isLabelVisible: option.unread > 0,
                    textColor: Colors.white,
                    backgroundColor: const Color(0xFFF04947),
                    child: AppImage.asset(option.icon,
                        width: 42.rpx, height: 42.rpx),
                  ),
                  SizedBox(height: 6.rpx),
                  Text(option.text),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Container _messageListContainer(MessageItem item,int index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: GestureDetector(
        onTap: () => controller.onTapSession(index),
        child: Container(
          margin: EdgeInsets.only(
              left: 12.rpx, right: 12.rpx, top: 14.rpx, bottom: 12.rpx),
          child: Row(
            children: [
              AppImage.asset(item.icon, width: 40.rpx, height: 40.rpx),
              SizedBox(width: 8.rpx),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 16.rpx,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 12.rpx),
                        Text(
                          item.time ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 12.rpx,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.rpx),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.detail ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF999999),
                                fontSize: 14.rpx),
                          ),
                        ),
                        Visibility(
                          visible: item.unread > 0,
                          child: Container(
                            height: 18.rpx,
                            margin: EdgeInsets.only(left: 12.rpx),
                            padding: EdgeInsets.symmetric(horizontal: 5.rpx, ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF04947),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                "${item.unread > 99 ? "99+" : item.unread}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.rpx,height: 1.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
