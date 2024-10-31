import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/im/chat_user_model.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class ContactListTile extends StatefulWidget {
  final ChatUserModel userModel;

  const ContactListTile({super.key, required this.userModel});

  @override
  State<ContactListTile> createState() => _ContactListTileState();
}

class _ContactListTileState extends State<ContactListTile> with AutoDisposeMixin {

  late ChatUserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    autoCancel(ChatUserManager().stream.listen((event) {
      final user = event[userModel.uid];
      if(user != null && user.createdAt > userModel.createdAt && user != userModel){
        setState(() {
          userModel = user.copyWith(signature: userModel.signature);
        });
      }
    }));
  }

  @override
  void didUpdateWidget(covariant ContactListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.userModel != widget.userModel){
      setState(() {
        userModel = widget.userModel;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toChatPage,
      child: Container(
        padding: FEdgeInsets(horizontal: 16.rpx, top: 12.rpx),
        child: Column(
          children: [
            Row(
              children: [
                buildAvatar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildName(),
                      if (userModel.signature?.isNotEmpty == true)
                        Padding(
                          padding: FEdgeInsets(top: 8.rpx),
                          child: Text(
                            userModel.signature ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.fs10.copyWith(
                              color: AppColor.grayText,
                              height: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                buildChatButton(),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.rpx),
              child: const Divider(
                  height: 1, thickness: 1, color: AppColor.background),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar() {
    Widget child = UserAvatar.circle(
      userModel.avatar ?? '',
      size: 40.rpx,
    );
    //在线
    if (userModel.onlineStatus == 0) {
      child = Stack(
        children: [
          child,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 10.rpx,
              height: 10.rpx,
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(width: 1.5.rpx, color: Colors.white),
                ),
                color: AppColor.green1D,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 8.rpx),
      child: GestureDetector(
        onTap: toUserPage,
        child: child,
      ),
    );
  }

  Widget buildName() {
    var nameMaxWidth = 224.rpx;

    final extendedChildren = <Widget>[
      if(userModel.gender!= null) Padding(
        padding: FEdgeInsets(left: 4.rpx),
        child: AppImage.asset(
          userModel.gender!.icon,
          size: 12.rpx,
        ),
      ),
    ];
    nameMaxWidth -= 16.rpx;

    //用户风格
    if (userModel.occupation != UserOccupation.unknown) {
      extendedChildren.add(
        Padding(
          padding: FEdgeInsets(left: 4.rpx),
          child: OccupationWidget(occupation: userModel.occupation),
        ),
      );
      nameMaxWidth -= 34.rpx;
    }

    //VIP图标
    if (userModel.nameplate?.startsWith('http') == true) {
      extendedChildren.add(
        Padding(
          padding: FEdgeInsets(left: 4.rpx),
          child: CachedNetworkImage(
            imageUrl: userModel.nameplate ?? '',
            height: 12.rpx,
          ),
        ),
      );
      nameMaxWidth -= 49.rpx;
    }

    return Row(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: nameMaxWidth),
          child: Text(
            userModel.nickname,
            style: AppTextStyle.fs14m.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...extendedChildren,
      ],
    );
  }

  Widget buildChatButton() {
    return GestureDetector(
      onTap: toChatPage,
      behavior: HitTestBehavior.translucent,
      child: AppImage.asset(
        'assets/images/chat/ic_hi_btn.png',
        width: 62.rpx,
        height: 24.rpx,
      ),
    );
  }

  void toUserPage() {
    Get.toNamed(AppRoutes.userCenterPage, arguments: {
      'userId': int.parse(userModel.uid),
    });
  }

  void toChatPage() {
    ChatManager().startChat(userId: int.parse(userModel.uid));
  }
}

extension on UserType {
  String get label {
    switch (this) {
      case UserType.user:
        return S.current.personage;
      case UserType.beauty:
        return S.current.goodGirl;
      case UserType.agent:
        return S.current.brokerP;
    }
  }
}
