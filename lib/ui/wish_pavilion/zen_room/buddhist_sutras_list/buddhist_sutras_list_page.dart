import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'buddhist_sutras_list_controller.dart';
import 'widgets/buddhist_sutras_cover.dart';

///经书列表
class BuddhistSutrasListPage extends StatelessWidget {
  final controller = Get.put(BuddhistSutrasListController());
  final state = Get.find<BuddhistSutrasListController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('佛经大全'),
      ),
      body: Column(
        children: [
          buildSearchInput(),
          buildDesc(),
          Expanded(child: buildGridView()),
        ],
      ),
    );
  }

  Widget buildSearchInput() {
    return Container(
      height: 36.rpx,
      margin: FEdgeInsets(all: 12.rpx),
      padding: FEdgeInsets(horizontal: 12.rpx),
      alignment: Alignment.center,
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.scaffoldBackground,
      ),
      child: TextField(
        style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5, height: 1.3),
        maxLines: 1,
        decoration: InputDecoration(
          hintText: '搜索经书名称',
          hintStyle: AppTextStyle.fs14m.copyWith(color: AppColor.gray10),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          isCollapsed: true,
          prefixIcon: Padding(
            padding: FEdgeInsets(right: 8.rpx),
            child: AppImage.asset('assets/images/common/ic_search_gray.png'),
          ),
          prefixIconConstraints: BoxConstraints.tightFor(height: 20.rpx),
          contentPadding: FEdgeInsets(horizontal: 12.rpx),
        ),
        onChanged: state.keywordRx.call,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) {
          controller.pagingController.refresh();
        },
      ),
    );
  }

  Widget buildDesc() {
    return Padding(
      padding: FEdgeInsets(horizontal: 12.rpx, bottom: 12.rpx),
      child: Obx((){
        final text = state.tipsRx();
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '“',
                style: AppTextStyle.fs20b.copyWith(color: AppColor.red1),
              ),
              TextSpan(
                text: text,
                style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildGridView() {
    final pagingController = controller.pagingController;
    return SmartRefresher(
      controller: pagingController.refreshController,
      onRefresh: pagingController.onRefresh,
      child: PagedGridView(
        padding: FEdgeInsets(horizontal: 12.rpx, bottom: 20.rpx),
        pagingController: pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 26.rpx,
          mainAxisSpacing: 20.rpx,
          childAspectRatio: 10 / 14,
        ),
        builderDelegate: DefaultPagedChildBuilderDelegate<BuddhistSutrasModel>(
            pagingController: pagingController,
            itemBuilder: (_, item, index) {
              return BuddhistSutrasCover(
                onTap: () => Get.back(result: item),
                name: item.name,
              );
            }),
      ),
    );
  }
}
