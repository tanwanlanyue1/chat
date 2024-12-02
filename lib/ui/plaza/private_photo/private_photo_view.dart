import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_detail/widget/private_photo_gallery_view.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_detail/widget/private_video_view.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_state.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_photo_list_item.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/app_color.dart';
import '../../../common/app_text_style.dart';
import '../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../common/paging/default_paged_child_builder_delegate.dart';
import '../../../common/routes/app_pages.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/spacing.dart';
import 'private_photo_controller.dart';

class PrivatePhotoView extends StatefulWidget {
  const PrivatePhotoView({super.key});

  @override
  State<PrivatePhotoView> createState() => _PrivatePhotoViewState();
}

class _PrivatePhotoViewState extends State<PrivatePhotoView> {
  final PrivatePhotoController controller = Get.put(PrivatePhotoController());
  final PrivatePhotoState state = Get.find<PrivatePhotoController>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        classifyTab(),
        Expanded(
          child: SmartRefresher(
            controller: controller.pagingController.refreshController,
            onRefresh: controller.pagingController.onRefresh,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                child: PagedGridView(
                  pagingController: controller.pagingController,
                  builderDelegate:
                      DefaultPagedChildBuilderDelegate<PlazaListModel>(
                    pagingController: controller.pagingController,
                    itemBuilder: (_, item, index) {
                      return PrivatePhotoListItem(
                        item: item,
                        onItemTap: () {
                          //Get.toNamed(AppRoutes.privatePhotoDetail);
                          if ((item.price ?? 0) > 0 &&
                              !(item.isUnlock ?? true)) {
                            controller.showPayDialog(item);
                          } else {
                            if (item.isVideo ?? false) {
                              PrivateVideoView.show(
                                  Get.context!,
                                  PrivateVideoView(
                                    item: item,
                                  ));
                            } else {
                              PrivatePhotoGalleryView.show(
                                  Get.context!,
                                  PrivatePhotoGalleryView(
                                    images: jsonDecode(item.images ?? ''),
                                    index: index,
                                    heroTag: '',
                                    item: item,
                                  ));
                            }

                            setState(() {
                              state.selectIndex = index;
                            });
                          }
                        },
                        isLook: state.selectIndex == index,
                        isLike: (like) {
                          controller.getCommentLike(like, index);
                        },
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 每行显示 3 列
                    mainAxisSpacing: 9.rpx, // 行间距
                    crossAxisSpacing: 8.rpx, // 列间距
                    mainAxisExtent: 219.rpx,
                  ),
                )),
          ),
        )
      ],
    );
  }

  Widget classifyTab() {
    return Padding(
        padding: EdgeInsets.only(bottom: 16.rpx, left: 16.rpx, top: 4.rpx),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Obx(() => Row(
                children: List<Widget>.generate(
                  state.communityTitle.length,
                  (i) => GestureDetector(
                    onTap: () {
                      state.communityIndex.value = i;
                      controller.pagingController.onRefresh();
                      controller.update(['floating']);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 26.rpx,
                      padding: EdgeInsets.symmetric(horizontal: 10.rpx),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.rpx),
                          color: Colors.white.withOpacity(0.2)),
                      child: Text(
                        '${state.communityTitle[i]}',
                        style: AppTextStyle.fs14.copyWith(
                            height: 1.0,
                            leadingDistribution: TextLeadingDistribution.even,
                            color: state.communityIndex.value == i
                                ? Color(0xFFF7BF4B)
                                : Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ).separated(Spacing.w8).toList(growable: false),
              )),

          ///发布
          _builPush(),
        ]));
  }

  ///发布按钮
  Widget _builPush() {
    return GestureDetector(
        onTap: () {
          // Get.toNamed(AppRoutes.releaseDynamicPage);
          Get.toNamed(AppRoutes.releaseMediaPage);
        },
        child: Container(
          alignment: Alignment.center,
          height: 24.rpx,
          width: 60.rpx,
          margin: EdgeInsets.only(right: 12.rpx),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.rpx),
            gradient: LinearGradient(colors: [
              Color(0xff0F73ED),
              Color(0xffC538FF),
            ],begin: Alignment.topLeft,end: Alignment.bottomRight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage.asset(
                "assets/images/plaza/push_ic.png",
                width: 16.rpx,
                height: 16.rpx,
              ),
              SizedBox(
                width: 4.rpx,
              ),
              Text(
                '发布',
                style: AppTextStyle.fs14.copyWith(
                    height: 1.0,
                    leadingDistribution: TextLeadingDistribution.even,color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
