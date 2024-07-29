import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'mine_fans_controller.dart';

class MineFansPage extends StatelessWidget {
  bool appBar;
  MineFansPage({Key? key,this.appBar = true}) : super(key: key);

  final controller = Get.put(MineFansController());
  final state = Get.find<MineFansController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: appBar ? AppBar(
        title: const Text("粉丝"),
      ):null,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView(
          padding:
              EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(top: 12.rpx),
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<UserModel>(
            pagingController: controller.pagingController,
            itemBuilder: (
              _,
              model,
              index,
            ) {
              return buildItem(model, index: index);
            },
          ),
        ),
      ),
    );
  }

  Widget buildItem(UserModel model, {required int index}) {
    final star = model.star ?? "";

    return GestureDetector(
      onTap: () => controller.onTapItem(model.uid),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: index == 0
              ? BorderRadius.vertical(top: Radius.circular(8.rpx))
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.rpx),
          child: Row(
            children: [
              AppImage.network(
                model.avatar ?? "",
                width: 32.rpx,
                height: 32.rpx,
                shape: BoxShape.circle,
              ),
              SizedBox(width: 8.rpx),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            model.nickname ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 12.rpx),
                          ),
                        ),
                        Visibility(
                          visible: star.isNotEmpty,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D310F),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.rpx)),
                            ),
                            margin: EdgeInsets.only(left: 8.rpx),
                            padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                            height: 14.rpx,
                            child: Center(
                              child: Text(
                                star,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.rpx,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEC88A),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.rpx)),
                          ),
                          margin: EdgeInsets.only(left: 8.rpx),
                          padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                          height: 14.rpx,
                          child: Center(
                            child: Text(
                              "Lv ${model.cavLevel}",
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.rpx,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // const Spacer(),
                      ],
                    ),
                    SizedBox(height: 2.rpx),
                    Row(
                      children: [
                        Text(
                          "粉丝:${model.fansNum}",
                          maxLines: 1,
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 10.rpx,
                          ),
                        ),
                        SizedBox(width: 24.rpx),
                        Text(
                          "${model.creationNum}创作",
                          maxLines: 1,
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 10.rpx,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.rpx),
              GetBuilder<MineFansController>(builder: (controller) {
                return TextButton(
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: MaterialStatePropertyAll(
                        bgColorForStatus(model.mutualFollow)),
                    minimumSize:
                        MaterialStateProperty.all(Size(50.rpx, 24.rpx)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.rpx),
                      ),
                    ),
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: () => controller.fetchAttention(index),
                  child: Text(
                    model.mutualFollow.title,
                    style: TextStyle(
                      color: textColorForStatus(model.mutualFollow),
                      fontSize: 12.rpx,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color textColorForStatus(UserAttentionStatus status) {
    switch (status) {
      case UserAttentionStatus.notFollowing:
        return Colors.white;
      default:
        return AppColor.gray5;
    }
  }

  Color bgColorForStatus(UserAttentionStatus status) {
    switch (status) {
      case UserAttentionStatus.notFollowing:
        return AppColor.primary;
      default:
        return AppColor.gray14;
    }
  }
}
