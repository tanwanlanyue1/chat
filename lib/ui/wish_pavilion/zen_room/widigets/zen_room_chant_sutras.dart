import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/network/api/wish_pavilion_api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/buddhist_sutras_list/widgets/buddhist_sutras_cover.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/chant_sutras_player_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../chant_sutras_player/chant_sutras_player_view.dart';

///禅房-底部的诵经面板
class ZenRoomChantSutras extends StatefulWidget {
  const ZenRoomChantSutras({super.key});

  @override
  State<ZenRoomChantSutras> createState() => _ZenRoomChantSutrasState();
}

class _ZenRoomChantSutrasState extends State<ZenRoomChantSutras>
    with AutoDisposeMixin, AutomaticKeepAliveClientMixin {

  ///经书数据控制器
  late final pagingController = DefaultPagingController<BuddhistSutrasModel>(
    firstPage: 1,
    pageSize: 20,
  )..addPageRequestListener(_fetchPage);

  final zenRoomController = Get.find<ZenRoomController>();

  ChantSutrasPlayerController get chantSutrasController => zenRoomController.chantSutrasController;


  ///播放经书
  void play(BuddhistSutrasModel model) => SS.login.requiredAuthorized(() {
    if (!model.audio.startsWith('http')) {
      Loading.showToast('该经书没有音频');
      return;
    }
    if(zenRoomController.state.selectedBuddhaRx() == null){
      Loading.showToast('请先恭请佛像');
      return;
    }
    chantSutrasController.play(model);
  });

  ///获取经书列表
  void _fetchPage(int page) async {
    final response = await WishPavilionApi.getBuddhistSutrasList(
      type: 0,
      page: page,
      size: pagingController.pageSize,
      isAudio: 1,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx((){
      final hasBuddha = zenRoomController.state.selectedBuddhaRx() != null;
      return Column(
        children: [
          Expanded(child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/wish_pavilion/zen_room/gifts_bg_mask.png'),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              color: Color(0xFF261C14),
            ),
            child: buildSutrasList(),
          )),
          Padding(
            padding: FEdgeInsets(bottom: hasBuddha ? 0 : Get.padding.bottom),
            child: hasBuddha ? const ChantSutrasPlayerView() : buildChooseBuddhaButton(),
          )
        ],
      );
    });
  }

  Widget buildChooseBuddhaButton() {
    return GestureDetector(
      onTap: zenRoomController.onTapChooseBuddha,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 48.rpx,
        alignment: Alignment.center,
        child: Text(
          '请先恭请佛像',
          style: AppTextStyle.fs16b.copyWith(
            color: AppColor.gold,
          ),
        ),
      ),
    );
  }

  Widget buildSutrasList() {
    return PagedListView.separated(
      padding: FEdgeInsets(horizontal: 12.rpx),
      scrollDirection: Axis.horizontal,
      pagingController: pagingController,
      builderDelegate: DefaultPagedChildBuilderDelegate<BuddhistSutrasModel>(
          pagingController: pagingController,
          firstPageErrorIndicatorBuilder: buildErrorIndicator,
          itemBuilder: (_, item, index) {
            return BuddhistSutrasCover(
              width: 60.rpx,
              height: 84.rpx,
              name: item.name,
              onTap: () {
                play(item);
              },
            );
          }),
      separatorBuilder: (_, index) => Spacing.w(20),
    );
  }

  Widget buildErrorIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage.asset(
            'assets/images/common/default_error.png',
            width: 60.rpx,
            height: 60.rpx,
          ),
          Button.outlineStadium(
            height: 32.rpx,
            width: 140.rpx,
            margin: FEdgeInsets(top: 4.rpx),
            onPressed: pagingController.retryLastFailedRequest,
            child: Text(
              '加载失败，点击重试',
              style: TextStyle(
                fontSize: 12.rpx,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
