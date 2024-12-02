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
        padding: EdgeInsets.only(bottom: 20.rpx, left: 16.rpx, top: 4.rpx),
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
                        gradient: LinearGradient(
                            colors: state.communityIndex.value == i
                                ? [
                                    AppColor.gradientBegin.withOpacity(0.1),
                                    AppColor.gradientBackgroundEnd
                                        .withOpacity(0.1),
                                  ]
                                : [
                                    AppColor.black9.withOpacity(0.1),
                                    AppColor.black9.withOpacity(0.1)
                                  ]),
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: state.communityIndex.value == i
                                ? [AppColor.gradientBegin, AppColor.gradientEnd]
                                : [AppColor.black6, AppColor.black6],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Text(
                          '${state.communityTitle[i]}',
                          style: AppTextStyle.fs14.copyWith(
                              height: 1.0,
                              leadingDistribution:
                                  TextLeadingDistribution.even),
                        ),
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
            height: 26.rpx,
            margin: EdgeInsets.only(right: 12.rpx),
            padding: EdgeInsets.symmetric(horizontal: 12.rpx, vertical: 4.rpx),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.rpx),
              gradient: LinearGradient(colors: [
                AppColor.black9.withOpacity(0.1),
                AppColor.black9.withOpacity(0.1)
              ]),
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColor.black6, AppColor.black6],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Text(
                '发布',
                style: AppTextStyle.fs14.copyWith(
                    height: 1.0,
                    leadingDistribution: TextLeadingDistribution.even),
              ),
            )));
  }
}
