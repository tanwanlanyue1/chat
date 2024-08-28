import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/contact/contact_view.dart';
import 'package:guanjia/ui/chat/conversation_list/conversation_list_view.dart';
import 'package:guanjia/ui/home/home_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/edge_insets.dart';

import 'chat_controller.dart';

///聊天TAB页
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(ChatController());
  final state = Get.find<ChatController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.chat),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: controller.tabController,
          labelStyle: AppTextStyle.fs14b,
          labelColor: AppColor.primaryBlue,
          unselectedLabelColor: AppColor.grayText,
          indicatorColor: AppColor.primaryBlue,
          indicatorWeight: 2.rpx,
          tabs: [
            ObxValue((dataRx){
              var text = S.current.message;
              if(dataRx() > 0){
                text += '（${dataRx()}）';
              }
              return Tab(text: text, height: 40.rpx);
            }, Get.find<HomeController>().state.messageUnreadRx),
            Tab(text: S.current.contact, height: 40.rpx),
          ],
        ),
      ),
      body: Obx(() {
        final callContent = state.callContent.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            TabBarView(
              controller: controller.tabController,
              children: const [
                ConversationListView(),
                ContactView(),
              ],
            ),
            if (callContent != null)
              Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: Container(
                  height: 258.rpx,
                  width: 311.rpx,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => controller.closeSpeedDatingDialog(),
                          icon: AppImage.asset(
                            'assets/images/common/close.png',
                            width: 24.rpx,
                            height: 24.rpx,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.rpx),
                      Container(
                        height: 40.rpx,
                        // width: 250.rpx,
                        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage.network(
                              callContent.avatar,
                              length: 40.rpx,
                              shape: BoxShape.circle,
                            ),
                            SizedBox(width: 8.rpx),
                            Flexible(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    callContent.nickname,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.st.medium
                                        .size(16.rpx)
                                        .copyWith(color: AppColor.black3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (callContent.gender !=
                                          UserGender.unknown)
                                        Padding(
                                          padding:
                                              EdgeInsets.only(right: 8.rpx),
                                          child: AppImage.asset(
                                            callContent.gender ==
                                                    UserGender.male
                                                ? "assets/images/mine/man.png"
                                                : "assets/images/mine/woman.png",
                                            length: 16.rpx,
                                          ),
                                        ),
                                      Text(
                                        "${callContent.age ?? " "}",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.st
                                            .size(12.rpx)
                                            .copyWith(color: AppColor.black3),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.rpx),
                      Text(
                        "该用户在实时${callContent.isVideo ? "视频" : "语音"}聊天匹配寻找好友",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.st.medium
                            .size(16.rpx)
                            .textHeight(1)
                            .copyWith(color: AppColor.black3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16.rpx),
                      Text(
                        "注：陪聊时间越长，可获得的收益越多哦～",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.st
                            .size(12.rpx)
                            .textHeight(1)
                            .copyWith(color: AppColor.black92),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: FEdgeInsets(
                          horizontal: 16.rpx,
                          top: 24.rpx,
                        ),
                        child: CommonGradientButton(
                          onTap: controller.onTapGrab,
                          height: 50.rpx,
                          text: "立即抢单",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
