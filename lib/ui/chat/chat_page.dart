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
import 'package:guanjia/ui/mine/inapp_message/models/call_match_content.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/user_avatar.dart';

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
      appBar: buildAppBar(),
      body: Obx(() {
        final callContent = state.callContent.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ConversationListView(),
                ContactView(),
              ],
            ),
            if (callContent != null) buildSpeedMatch(callContent),
          ],
        );
      }),
    );
  }

  Widget buildSpeedMatch(CallMatchContent callContent){
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () =>
                    controller.closeSpeedDatingDialog(),
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
                  UserAvatar.circle(
                    callContent.avatar,
                    size: 40.rpx,
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
                                  size: 16.rpx,
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
              callContent.isVideo
                  ? S.current.theUserVideo
                  : S.current.theUserVoice,
              textAlign: TextAlign.center,
              style: AppTextStyle.fs16m
                  .textHeight(1)
                  .copyWith(color: AppColor.blackBlue),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              alignment: Alignment.center,
              padding: FEdgeInsets(top: 16.rpx),
              child: Text(
                S.current.longerConversationMoreMoney,
                textAlign: TextAlign.start,
                style: AppTextStyle.fs12
                    .textHeight(1)
                    .copyWith(color: AppColor.black92),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: FEdgeInsets(
                horizontal: 16.rpx,
                vertical: 24.rpx,
              ),
              child: CommonGradientButton(
                onTap: controller.onTapGrab,
                height: 50.rpx,
                text: S.current.takeOrdersImmediately,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: TabBar(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        controller: controller.tabController,
        labelStyle: AppTextStyle.bold.copyWith(fontSize: 22.rpx),
        unselectedLabelStyle: AppTextStyle.fs16,
        labelColor: AppColor.blackBlue,
        unselectedLabelColor: AppColor.grayText,
        isScrollable: true,
        labelPadding: FEdgeInsets.zero,
        indicatorWeight: 0.1,
        indicatorColor: Colors.transparent,
        tabs: [
          ObxValue((dataRx) {
            Widget child = Text(S.current.message);
            if (dataRx() > 0) {
              // text += '（${dataRx()}）';
              child = Text.rich(TextSpan(
                children: [
                  TextSpan(text: S.current.message),
                  TextSpan(text: '(${dataRx()})', style: AppTextStyle.fs12m),
                ]
              ));
            }

            return Tab(height: 40.rpx, child: child);
          }, Get.find<HomeController>().state.messageUnreadRx),
          Tab(
            height: 40.rpx,
            child: Padding(
              padding: FEdgeInsets(horizontal: 20.rpx),
              child: Text(S.current.contact),
            ),
          ),
        ],
      ),
    );
  }

  ///渐变背景
  Widget wrapGradientBackground({required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Container(
            height: 200.rpx,
            decoration: const BoxDecoration(
              gradient: AppColor.verticalGradientBaby,
            ),
          ),
        ),
        child,
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
