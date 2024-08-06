import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';

///聊天更多功能面板
class ChatFeaturePanel extends StatelessWidget {
  final Function(ChatFeatureAction action)? onTap;
  final List<ChatFeatureAction> actions;

  const ChatFeaturePanel({
    super.key,
    required this.onTap,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.rpx,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: MediaQuery.of(context).size.width/4/90,
        ),
        itemCount: actions.length,
        itemBuilder: (_, index) {
          return buildItem(actions[index]);
        },
      ),
    );
  }

  Widget buildItem(ChatFeatureAction item) {
    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage.asset(
            item.icon,
            width: 40.rpx,
            height: 40.rpx,
          ),
          Padding(
            padding: FEdgeInsets(top: 6.rpx),
            child: Text(
              item.label,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.gray9,
                height: 1.00001,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///功能操作
enum ChatFeatureAction {
  ///图片
  picture,

  ///视频录制
  recordVideo,

  ///位置
  location,

  ///红包
  redPacket,

  ///语音通话
  voiceCall,

  ///视频通话
  videoCall,

  ///发起约会
  date,

  ///转账
  transfer,
}

extension on ChatFeatureAction {
  String get label {
    switch (this) {
      case ChatFeatureAction.picture:
        return '图片';
      case ChatFeatureAction.recordVideo:
        return '拍摄';
      case ChatFeatureAction.location:
        return '位置';
      case ChatFeatureAction.redPacket:
        return '红包';
      case ChatFeatureAction.voiceCall:
        return '实时语音';
      case ChatFeatureAction.videoCall:
        return '视频认证';
      case ChatFeatureAction.date:
        return '发起约会';
      case ChatFeatureAction.transfer:
        return '转账';
    }
  }

  String get icon {
    switch (this) {
      case ChatFeatureAction.picture:
        return 'assets/images/chat/ic_action_picture.png';
      case ChatFeatureAction.recordVideo:
        return 'assets/images/chat/ic_action_record_video.png';
      case ChatFeatureAction.location:
        return 'assets/images/chat/ic_action_location.png';
      case ChatFeatureAction.redPacket:
        return 'assets/images/chat/ic_action_redpacket.png';
      case ChatFeatureAction.voiceCall:
        return 'assets/images/chat/ic_action_voice_call.png';
      case ChatFeatureAction.videoCall:
        return 'assets/images/chat/ic_action_video_call.png';
      case ChatFeatureAction.date:
        return 'assets/images/chat/ic_action_date.png';
      case ChatFeatureAction.transfer:
        return 'assets/images/chat/ic_action_transfer.png';
    }
  }
}
