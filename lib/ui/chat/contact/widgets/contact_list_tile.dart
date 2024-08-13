import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

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
        padding: EdgeInsets.only(left: 16.rpx, right: 14.rpx, top: 24.rpx),
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
                SizedBox(
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
                                maxWidth: Get.width-200.rpx
                            ),
                            child: Text(userModel.nickname,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                          AppImage.asset(
                            "assets/images/mine/safety.png",
                            width: 16.rpx,
                            height: 16.rpx,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: userModel.gender == UserGender.female,
                            replacement: AppImage.asset(
                              "assets/images/mine/man.png",
                              width: 16.rpx,
                              height: 16.rpx,
                            ),
                            child: AppImage.asset(
                              "assets/images/mine/woman.png",
                              width: 16.rpx,
                              height: 16.rpx,
                            ),
                          ),
                          SizedBox(width: 8.rpx),
                          if(age > 0) ...[
                            Text(
                              age.toString(),
                              style: AppTextStyle.fs12m
                                  .copyWith(color: AppColor.gray30),
                            ),
                            Container(
                              width: 4.rpx,
                              height: 4.rpx,
                              margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                              decoration: const BoxDecoration(
                                color: AppColor.black6,
                                shape: BoxShape.circle,
                              ),
                            )
                          ],
                          Text(
                            userModel.type.label,
                            style: AppTextStyle.fs12m
                                .copyWith(color: AppColor.gray30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Button.stadium(
                  onPressed: toChatPage,
                  width: 82.rpx,
                  height: 28.rpx,
                  backgroundColor: userModel.gender == UserGender.female ? AppColor.purple6 : AppColor.blue6,
                  child: Text(
                    '发起聊天',
                    style: AppTextStyle.fs12m.copyWith(color: Colors.white),
                  ),
                )
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
      ),
    );
  }

  void toChatPage(){
    MessageListPage.go(userId: userModel.uid);
  }

  void toUserPage(){
    Get.toNamed(AppRoutes.userCenterPage, arguments: {
      'userId': userModel.uid,
    });
  }
}

extension on UserType {
  String get label{
    switch(this){
      case UserType.user:
        return '个人';
      case UserType.beauty:
        return '佳丽';
      case UserType.agent:
        return '经纪人';
    }
  }
}
