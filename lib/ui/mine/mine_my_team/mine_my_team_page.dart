import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
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
      ),
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
          child: PagedListView(
            pagingController: controller.pagingController,
            builderDelegate: DefaultPagedChildBuilderDelegate<UserModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return jiaItem(item);
              },
            ),
          )
      ),
    );
  }

  //佳丽列表
  Widget jiaItem(UserModel item){
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
                  child: AppImage.network(item.avatar ?? '',width: 40.rpx,height: 40.rpx,shape: BoxShape.circle,),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40.rpx,
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
                            child: Text(item.nickname,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),maxLines: 1,overflow: TextOverflow.ellipsis),
                          ),
                          AppImage.asset("assets/images/mine/safety.png",width: 16.rpx,height: 16.rpx,),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: item.gender.isMale,
                            replacement: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                            child: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          ),
                          SizedBox(width: 8.rpx),
                          Text('${item.age}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                          Container(
                            width: 4.rpx,
                            height: 4.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                            decoration: const BoxDecoration(
                              color: AppColor.black9,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(S.current.goodGirl,style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.dialog(
                    cancellingPop(),
                  );
                },
                child: Container(
                  height: 40.rpx,
                  margin: EdgeInsets.only(right: 24.rpx),
                  alignment: Alignment.topCenter,
                  color: Colors.transparent,
                  child: AppImage.asset("assets/images/mine/cancelAContract.png",width: 20.rpx,height: 20.rpx,),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.dialog(
                    cancellingPop(),
                  );
                },
                child: Container(
                  height: 40.rpx,
                  margin: EdgeInsets.only(right: 24.rpx),
                  child: Column(
                    children: [
                      AppImage.asset("assets/images/mine/look_contract_detail.png",width: 20.rpx,height: 20.rpx,),
                      SizedBox(height: 2.rpx,),
                      Text(S.current.contract,style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  MessageListPage.go(userId: item.uid);
                },
                child: Column(
                  children: [
                    AppImage.asset("assets/images/mine/relation.png",width: 20.rpx,height: 20.rpx,),
                    SizedBox(height: 2.rpx,),
                    Text(S.current.contactBeauty,style: AppTextStyle.fs12m.copyWith(color: AppColor.purple6)),
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

  //解约弹窗
  Widget cancellingPop(){
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: Container(
          width: 311.rpx,
          height: 173.rpx,
          padding: EdgeInsets.only(top: 16.rpx,bottom: 24.rpx),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.rpx),
                  alignment: Alignment.centerRight,
                  child: AppImage.asset("assets/images/common/close.png",width: 24.rpx,height: 24.rpx,),
                ),
              ),
              Text("确定和该位佳丽解约吗？",style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 120.rpx,
                      height: 50.rpx,
                      decoration: BoxDecoration(
                        color: AppColor.black9,
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      alignment: Alignment.center,
                      child: Text("取消",style: AppTextStyle.fs16m.copyWith(color: Colors.white),),
                    ),
                  ),
                  SizedBox(
                    width: 120.rpx,
                    child: CommonGradientButton(
                      height: 50.rpx,
                      text: '立即解约',
                      onTap: (){
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
