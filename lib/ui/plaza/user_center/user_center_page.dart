import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'user_center_controller.dart';

///广场-用户中心
class UserCenterPage extends StatelessWidget {
  final String? userId; //用户id
  UserCenterPage({Key? key,this.userId}) : super(key: key);

  final controller = Get.put(UserCenterController());
  final state = Get.find<UserCenterController>().state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppImage.asset(
          "assets/images/plaza/user_center_back.png",
          fit: BoxFit.fitWidth,
        ),
        Column(
          children: [
            topBar(),
            userInfo(),
            Expanded(
              child: creativeDynamics(),
            ),
          ],
        )
      ],
    );
  }

  ///头部
  Widget topBar() {
    return Container(
      margin: EdgeInsets.only(
          right: 12.rpx, top: Get.mediaQuery.padding.top + 12.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBackButton.dark(),
          // Container(
          //   width: 40.rpx,
          //   height: 50.rpx, // 设置高度
          //   alignment: Alignment.center,
          //   child: PopupMenuButton(
          //     offset: Offset(0, 40.rpx),
          //     icon: AppImage.asset(
          //       "assets/images/plaza/more.png",
          //       width: 24.rpx,
          //       height: 24.rpx,
          //     ),
          //     itemBuilder: (_) => ['举报', '拉黑'].map((e) {
          //       return PopupMenuItem<String>(
          //         value: e,
          //         child: Text(e,style: TextStyle(color: Color(0xff333333),fontSize: 14.rpx),),
          //       );
          //     }).toList(),
          //     onSelected: (value) async {
          //       if (value == '举报') {
          //         ShowBottomSheet.reportType();
          //       } else if (value == '拉黑') {
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  ///用户信息
  Widget userInfo(){
    return GetBuilder<UserCenterController>(
      id: "userInfo",
      builder: (_){
        return Container(
          margin: EdgeInsets.only(top: 8.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImage.network(
                      state.authorInfo.avatar ?? "",
                      width: 40.rpx,
                      height: 40.rpx,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(width: 8.rpx),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.authorInfo.nickname ?? "",
                            style: TextStyle(
                                fontSize: 16.rpx,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4.rpx,),
                          Row(
                            children: [
                              Visibility(
                                visible: state.authorInfo.star != null && state.authorInfo.star!.isNotEmpty,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xff8D310F),
                                      borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                                  ),
                                  margin: EdgeInsets.only(right: 6.rpx),
                                  padding: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
                                  height: 14.rpx,
                                  child: Text(state.authorInfo.star ?? "",style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1.3),),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffEEC88A),
                                    borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                                ),
                                padding: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
                                height: 14.rpx,
                                child: Text("Lv.${state.authorInfo.cavLevel}",style: TextStyle(fontSize: 10.rpx,color: Colors.white),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: SS.login.userId != state.authorInfo.uid,
                      child: GestureDetector(
                        onTap: controller.attention,
                        child: Container(
                          width: 56.rpx,
                          height: 26.rpx,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: state.isAttention ? AppColor.gray39 : Colors.transparent,
                              border: Border.all(width: 1.rpx,color: state.isAttention ? Colors.transparent : Color(0xff8D310F)),
                              borderRadius: BorderRadius.all(Radius.circular(13.rpx))
                          ),
                          child: Visibility(
                            visible: state.isAttention,
                            replacement: Text("+关注",style: TextStyle(color: const Color(0xff8D310F),fontSize: 12.rpx),),
                            child: Text("已关注",style: TextStyle(color: AppColor.gray5,fontSize: 12.rpx),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(12.rpx),
                  child: Text(state.authorInfo.signature ?? "",style: TextStyle(color: const Color(0xff684326),fontSize: 12.rpx),)
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 12.rpx),
              //   child: Row(
              //     children: List.generate(4, (index) => Container(
              //       height: 14.rpx,
              //       decoration: BoxDecoration(
              //         color: const Color(0xffEBDACD),
              //         border: Border.all(width: 1.rpx,color: const Color(0xff8D310F)),
              //         borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(4.rpx),
              //           topRight: Radius.circular(4.rpx),
              //         ),
              //       ),
              //       padding: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
              //       margin: EdgeInsets.only(right: 6.rpx),
              //       child: Text("摩羯座",style: TextStyle(fontSize: 10.rpx,color: const Color(0xff8D310F),height: 1.199999999),),
              //     )),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.rpx),
                    bottomRight: Radius.circular(20.rpx),
                  ),
                ),
                height: 40.rpx,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("创作:",style: TextStyle(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.rpx,
                    ),),
                    Container(
                      margin: EdgeInsets.only(left: 8.rpx,right: 12.rpx),
                      padding: EdgeInsets.only(right: 24.rpx),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.rpx, color: const Color(0XffEFEFEF))),
                      ),
                      child: Text("${state.creation['creationCount'] ?? 0}",style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.rpx,
                      ),),
                    ),
                    Text("粉丝:",style: TextStyle(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.rpx,
                    ),),
                    Container(
                      margin: EdgeInsets.only(left: 8.rpx,right: 12.rpx),
                      padding: EdgeInsets.only(right: 24.rpx),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.rpx, color: const Color(0XffEFEFEF))),
                      ),
                      child: Text("${state.creation['fansCount'] ?? 0}",style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.rpx,
                      ),),
                    ),
                    Text("关注:",style: TextStyle(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.rpx,
                    ),),
                    Container(
                      margin: EdgeInsets.only(left: 8.rpx),
                      child: Text("${state.creation['followCount'] ?? 0}",style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.rpx,
                      ),),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12.rpx,left: 12.rpx),
                color: AppColor.scaffoldBackground,
                alignment: Alignment.centerLeft,
                child: Text("创作动态",style: TextStyle(fontSize: 14.rpx,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }

  ///创作动态
  Widget creativeDynamics(){
    return Container(
      color: AppColor.scaffoldBackground,
      padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 10.rpx),
      child: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView(
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_,item,index){
                var prevItem = controller.pagingController.itemList?.tryGet(index - 1);
                return Column(
                  children: [
                    Visibility(
                      visible: controller.acquisitionMonth(item) != controller.acquisitionMonth(prevItem),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 2.rpx,
                                height: 9.rpx,
                                color:  index != 0 ? const Color(0xffE6DADA):null,
                              ),
                              Container(
                                width: 6.rpx,
                                height: 6.rpx,
                                decoration: const BoxDecoration(color: Color(0xff8D310F),shape: BoxShape.circle,),
                              ),
                              Container(
                                width: 2.rpx,
                                height: 9.rpx,
                                color: const Color(0xffE6DADA),
                              ),
                            ],
                          ),
                          Container(
                            width: 50.rpx,
                            height: 24.rpx,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(205, 205, 205, 0.15),
                                borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                            ),
                            margin: EdgeInsets.only(left: 8.rpx),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: '${controller.acquisitionMonth(item)} ',
                                // text: '${item['month']} ',
                                style: TextStyle(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.rpx,
                                ),
                                children: [
                                  TextSpan(
                                    text: '月',
                                    style: TextStyle(
                                      color: const Color(0xff999999),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.rpx,
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 2.rpx,
                            color: const Color(0xffE6DADA),
                            margin: EdgeInsets.only(left: 2.rpx,right: 12.rpx),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.rpx),
                              child: PlazaCard(
                                item: item,
                                user: true,
                                isCollect: (collect){
                                  controller.getCommentCollect(collect,index);
                                },
                                isLike: (like){
                                  controller.getCommentLike(like, index);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
