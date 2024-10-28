import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class ContactListTile extends StatelessWidget {
  final UserModel userModel;

  const ContactListTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final age = userModel.age ?? 0;
    return GestureDetector(
      onTap: toUserPage,
      child: Container(
        color: Colors.white,
        padding: FEdgeInsets(horizontal: 16.rpx, top: 24.rpx),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(
                    userModel.avatar ?? '',
                    shape: BoxShape.circle,
                    width: 40.rpx,
                    height: 40.rpx,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.rpx),
                          constraints:
                              BoxConstraints(maxWidth: Get.width - 200.rpx),
                          child: Text(
                            userModel.nickname,
                            style: AppTextStyle.fs14.copyWith(
                              color: AppColor.blackBlue,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // AppImage.asset(
                        //   "assets/images/mine/safety.png",
                        //   width: 16.rpx,
                        //   height: 16.rpx,
                        // ),
                      ],
                    ),
                    Spacing.h8,
                    Row(
                      children: [
                        if (userModel.gender.icon != null)
                          Padding(
                            padding: FEdgeInsets(right: 8.rpx),
                            child: AppImage.asset(
                              userModel.gender.icon ?? '',
                              width: 16.rpx,
                              height: 16.rpx,
                            ),
                          ),
                        if (age > 0) ...[
                          Text(
                            age.toString(),
                            style: AppTextStyle.fs12r.copyWith(
                              color: AppColor.blackBlue.withOpacity(0.7),
                            ),
                          ),
                          Container(
                            width: 4.rpx,
                            height: 4.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                            decoration: const BoxDecoration(
                              color: AppColor.grayText,
                              shape: BoxShape.circle,
                            ),
                          )
                        ],
                        Text(
                          userModel.type.label,
                          style: AppTextStyle.fs12r.copyWith(
                            color: AppColor.blackBlue.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                buildChatButton(),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.rpx),
              child: Divider(height: 1, endIndent: 16.rpx, indent: 16.rpx),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatButton() {
    return GestureDetector(
      onTap: toChatPage,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: const ShapeDecoration(
          shape: StadiumBorder(),
          gradient: LinearGradient(
            colors: [AppColor.purple4, AppColor.purple8],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: 32.rpx,
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: FEdgeInsets(horizontal: 10.rpx),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: StadiumBorder(),
          ),
          child: Row(
            children: [
              AppImage.asset(
                'assets/images/plaza/accost.png',
                width: 20.rpx,
                height: 20.rpx,
              ),
              Padding(
                padding: FEdgeInsets(left: 4.rpx),
                child: Text(
                  S.current.accost,
                  style: AppTextStyle.fs14r.copyWith(
                    color: AppColor.blackBlue,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toUserPage() {
    Get.toNamed(AppRoutes.userCenterPage, arguments: {
      'userId': userModel.uid,
    });
  }

  void toChatPage() {
    ChatManager().startChat(userId: userModel.uid);
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
