import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'contact_controller.dart';
import 'widgets/contact_list_tile.dart';

///通讯录
class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(ContactController());
  final state = Get.find<ContactController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: controller.pagingController.refreshController,
      onRefresh: controller.pagingController.onRefresh,
      child: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   backgroundColor: Colors.transparent,
          //   automaticallyImplyLeading: false,
          //   pinned: true,
          //   snap: false,
          //   floating: false,
          //   expandedHeight: 184.rpx,
          //   toolbarHeight: 80.rpx,
          //   flexibleSpace: FlexibleSpaceBar(
          //     collapseMode: CollapseMode.pin,
          //     stretchModes: const [StretchMode.blurBackground],
          //     expandedTitleScale: 1.0,
          //     background: buildUserInfo(),
          //     title: buildSearch(),
          //     titlePadding: EdgeInsets.zero,
          //   ),
          // ),
          SliverToBoxAdapter(child: buildUserInfo()),
          SliverToBoxAdapter(child: buildSearch()),
          SliverToBoxAdapter(
            child: Divider(height: 1, endIndent: 16.rpx, indent: 16.rpx),
          ),
          PagedSliverList(
            pagingController: controller.pagingController,
            builderDelegate: DefaultPagedChildBuilderDelegate<UserModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return ContactListTile(userModel: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  ///用户信息
  Widget buildUserInfo() {
    return Container(
      padding: FEdgeInsets(top: 24.rpx),
      alignment: Alignment.topCenter,
      child: Obx(() {
        final userInfo = SS.login.info;
        final isVip = SS.login.isVip;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.userCenterPage, arguments: {'userId': userInfo?.uid});
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AppImage.network(
                    userInfo?.avatar ?? '',
                    width: 80.rpx,
                    height: 80.rpx,
                    shape: BoxShape.circle,
                  ),
                  if(isVip) AppImage.asset(
                    'assets/images/mine/ic_vip.png',
                    width: 24.rpx,
                    height: 24.rpx,
                  ),
                ],
              ),
            ),
            Spacing.w12,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                  child: Text(
                    maxLines: 2,
                    userInfo?.nickname ?? '',
                    style: AppTextStyle.fs16m.copyWith(
                      color: AppColor.blackBlue,
                      height: 1.0,
                    ),
                  ),
                ),
                if (userInfo?.position?.isNotEmpty == true)
                  Padding(
                    padding: FEdgeInsets(top: 8.rpx),
                    child: Text(
                      userInfo?.position ?? '',
                      style: AppTextStyle.fs12.copyWith(
                        color: AppColor.grayText,
                        height: 1.0,
                      ),
                    ),
                  ),
                if (userInfo?.chatNo != null)
                  GestureDetector(
                    onTap: () => '${userInfo?.chatNo}'.copy(),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: FEdgeInsets(top: 8.rpx),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ID:${userInfo?.chatNo}',
                            style: AppTextStyle.fs12.copyWith(
                              color: AppColor.grayText,
                              height: 1.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.rpx),
                            child: AppImage.asset(
                              'assets/images/mine/ic_copy.png',
                              width: 16.rpx,
                              height: 16.rpx,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  ///搜索框
  Widget buildSearch() {
    return Container(
      width: double.infinity,
      height: 62.rpx,
      padding: FEdgeInsets(left: 16.rpx, right: 8.rpx),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.rpx,
              child: TextField(
                controller: controller.editingController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                style: AppTextStyle.fs14m.copyWith(
                  color: AppColor.blackBlue,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.background,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.rpx),
                    gapPadding: 0,
                  ),
                  hintStyle: AppTextStyle.fs14.copyWith(
                    color: AppColor.grayText,
                  ),
                  hintText: S.current.contactSearchHint,
                  contentPadding: FEdgeInsets(horizontal: 16.rpx),
                  suffixIcon: AnimatedBuilder(
                    animation: controller.editingController,
                    builder: (_, child) {
                      return Visibility(
                        visible: controller.editingController.text.isNotEmpty,
                        child: Button.icon(
                          width: 40.rpx,
                          onPressed: controller.editingController.clear,
                          icon: AppImage.asset(
                            'assets/images/mine/ic_clear.png',
                            width: 24.rpx,
                            height: 24.rpx,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: controller.doSearch,
            icon: AppImage.asset(
              'assets/images/mine/ic_search.png',
              width: 24.rpx,
              height: 24.rpx,
            ),
          ),
        ],
      ),
    );
  }
}
