import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

class ContactListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final UserModel userModel;

  const ContactListTile({super.key, this.onTap, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final age = userModel.age ?? 0;
    return Container(
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
                        Text(
                          userModel.nickname,
                          style: AppTextStyle.fs14m
                              .copyWith(color: AppColor.gray5),
                        ),
                        SizedBox(width: 8.rpx),
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
                          "${S.current.yesterday} 09:35",
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
                onPressed: onTap,
                width: 82.rpx,
                height: 28.rpx,
                backgroundColor: AppColor.purple6,
                child: Text(
                  S.current.getTouchWith,
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
    );
  }
}
