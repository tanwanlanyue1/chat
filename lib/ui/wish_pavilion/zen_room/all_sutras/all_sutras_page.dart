import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/chant_sutras_player_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/chant_sutras_player/chant_sutras_player_view.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../widigets/sutras_list_tile.dart';
import 'all_sutras_controller.dart';

///经书列表（数据与BuddhistSutrasListPage一样，只是样式不一样 ）
class AllSutrasPage extends StatelessWidget {
  final controller = Get.put(AllSutrasController());
  final state = Get.find<AllSutrasController>().state;

  ChantSutrasPlayerController get chantSutrasController =>
      Get.find<ZenRoomController>().chantSutrasController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('经书'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AppAssetImage(
              'assets/images/wish_pavilion/zen_room/sutras_list_bg.png'),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
        )),
        child: Container(
          margin: FEdgeInsets(
              top: MediaQuery.of(context).padding.top + kToolbarHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.rpx)),
            color: Colors.white,
          ),
          child: AnimatedBuilder(
            animation: chantSutrasController,
            builder: (_, child) {
              final pagingController = controller.pagingController;
              final currentSutras = chantSutrasController.currentSutras;
              return Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: pagingController.refreshController,
                      onRefresh: pagingController.onRefresh,
                      child: PagedListView.separated(
                        pagingController: pagingController,
                        padding: FEdgeInsets(
                            top: 8.rpx,
                            bottom: MediaQuery.of(context).padding.bottom),
                        separatorBuilder: (_, index) {
                          return Divider(
                              height: 0, indent: 12.rpx, endIndent: 12.rpx);
                        },
                        builderDelegate: DefaultPagedChildBuilderDelegate<
                            BuddhistSutrasModel>(
                          pagingController: pagingController,
                          itemBuilder: (_, item, index) {
                            return SutrasListTile(
                              item: item,
                              isPlaying: chantSutrasController.playing && item.id == currentSutras?.id,
                              isCurrent: item.id == currentSutras?.id,
                              onTapPlay: () {
                                chantSutrasController.play(item);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (currentSutras != null)
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          blurRadius: 5.rpx,
                          offset: Offset(0, -1.rpx),
                          color: const Color(0x128D310F),
                        )
                      ]),
                      child: ChantSutrasPlayerView(
                        backgroundColor: Colors.white,
                        isVisibleAll: false,
                        textStyle:
                            AppTextStyle.fs14m.copyWith(color: Colors.black),
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
