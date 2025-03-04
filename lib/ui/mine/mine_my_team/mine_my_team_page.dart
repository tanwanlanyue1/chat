import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/user_avatar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_my_team_controller.dart';

//我的-我的团队
class MineMyTeamPage extends StatelessWidget {
  MineMyTeamPage({Key? key}) : super(key: key);

  final controller = Get.put(MineMyTeamController());
  final state = Get.find<MineMyTeamController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.teamList),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.grayF7,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
          child: CustomScrollView(
            slivers: [
              PagedSliverList(
                  pagingController: controller.pagingController,
                  builderDelegate: DefaultPagedChildBuilderDelegate<TeamUser>(
                    pagingController: controller.pagingController,
                    itemBuilder: (_, item, index) {
                      return jiaItem(item,index);
                    },
                  )
              ),
              SliverToBoxAdapter(
                child: Obx(() => Visibility(
                  visible: state.total.value > 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 24.rpx,bottom: 24.rpx),
                    alignment: Alignment.center,
                    child: Text(S.current.totalArtist(state.total),style: AppTextStyle.fs12.copyWith(color: AppColor.black999),),
                  ),
                )),
              ),
            ],
          )
      ),
    );
  }

  //佳丽列表
  Widget jiaItem(TeamUser item,int index){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.rpx,right: 14.rpx,top: 24.rpx),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.userCenterPage,arguments: {'userId': item.uid});
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: UserAvatar.circle(item.avatar ?? '',size: 40.rpx),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40.rpx,
                  margin: EdgeInsets.only(right: 4.rpx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8.rpx),
                            constraints: BoxConstraints(
                                maxWidth: Get.width-240.rpx
                            ),
                            child: Text(item.nickname ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),maxLines: 1,overflow: TextOverflow.ellipsis),
                          ),
                          // AppImage.asset("assets/images/mine/safety.png",width: 16.rpx,height: 16.rpx,),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: item.gender != 0,
                            child: Visibility(
                              visible: item.gender == 1,
                              replacement: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                              child: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                            ),
                          ),
                          SizedBox(width: 8.rpx),
                          Text('${item.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.blue56),),
                          Container(
                            width: 4.rpx,
                            height: 4.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                            decoration: const BoxDecoration(
                              color: AppColor.black9,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(S.current.goodGirl,style: AppTextStyle.fs12m.copyWith(color: AppColor.blue56),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                // visible: item.remark == 'apply',
                child: GestureDetector(
                  onTap: (){
                    controller.getContract(item.contractId!,index: index);
                  },
                  child: Container(
                    height: 40.rpx,
                    margin: EdgeInsets.only(right: 16.rpx),
                    alignment: Alignment.topCenter,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        AppImage.asset("assets/images/mine/cancelAContract.png",width: 20.rpx,height: 20.rpx,),
                        SizedBox(height: 2.rpx,),
                        Text(S.current.cancelContract,style: AppTextStyle.fs12.copyWith(color: AppColor.black999),),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.getContract(item.contractId!,detail: true);
                },
                child: Container(
                  height: 40.rpx,
                  margin: EdgeInsets.only(right: 16.rpx),
                  child: Column(
                    children: [
                      AppImage.asset("assets/images/mine/look_contract_detail.png",width: 20.rpx,height: 20.rpx,),
                      SizedBox(height: 2.rpx,),
                      Text(S.current.contract,style: AppTextStyle.fs12.copyWith(color: AppColor.primary),),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  ChatManager().startChat(userId: item.uid!);
                },
                child: Column(
                  children: [
                    AppImage.asset("assets/images/mine/relation.png",width: 20.rpx,height: 20.rpx,),
                    SizedBox(height: 2.rpx,),
                    Text(S.current.contactBeauty,style: AppTextStyle.fs12.copyWith(color: AppColor.purple6)),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 1.rpx,
            alignment: Alignment.center,
            color: AppColor.scaffoldBackground,
            margin: EdgeInsets.only(top: 24.rpx),
          ),
        ],
      ),
    );
  }

}
