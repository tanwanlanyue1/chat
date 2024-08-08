// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/src/components/audio_video/audio_video_view.dart';
import 'package:zego_uikit/src/components/audio_video/defines.dart';
import 'package:zego_uikit/src/components/audio_video_container/layout.dart';
import 'package:zego_uikit/src/components/audio_video_container/picture_in_picture/defines.dart';
import 'package:zego_uikit/src/components/audio_video_container/picture_in_picture/layout_pip_small_item.dart';
import 'package:zego_uikit/src/components/audio_video_container/picture_in_picture/layout_pip_small_item_list.dart';
import 'package:zego_uikit/src/components/defines.dart';
import 'package:zego_uikit/src/services/services.dart';

/// layout config of picture in picture
class ZegoLayoutPictureInPictureConfig extends ZegoLayout {
  /// small video view is draggable if set true in one-on-one mode
  bool isSmallViewDraggable;

  ///  Whether you can switch view's position by clicking on the small view
  bool switchLargeOrSmallViewByClick;

  /// default position of small video view
  ZegoViewPosition smallViewPosition;

  /// the margin of PIP view
  EdgeInsets? margin;

  /// the size of every small view
  Size? smallViewSize;

  /// the space between small views in multi-users mode
  EdgeInsets? spacingBetweenSmallViews;

  /// small video views is scrollable if set true in multi-users mode
  bool isSmallViewsScrollable;

  /// the visible small views count in multi-users mode
  /// if the value is set to -1, it will attempt to display the maximum number of views.
  int visibleSmallViewsCount;

  ///
  bool showNewScreenSharingViewInFullscreenMode;

  ///
  ZegoShowFullscreenModeToggleButtonRules
      showScreenSharingFullscreenModeToggleButtonRules;

  ///小窗口是否只在视频通话时显示
  bool isSmallViewShowOnlyVideo;
  

  ZegoLayoutPictureInPictureConfig({
    this.isSmallViewDraggable = true,
    this.switchLargeOrSmallViewByClick = true,
    this.smallViewPosition = ZegoViewPosition.topRight,
    this.margin,
    this.smallViewSize,
    this.spacingBetweenSmallViews,
    this.isSmallViewsScrollable = true,
    this.visibleSmallViewsCount = 3,
    this.showNewScreenSharingViewInFullscreenMode = true,
    this.showScreenSharingFullscreenModeToggleButtonRules =
        ZegoShowFullscreenModeToggleButtonRules.showWhenScreenPressed,
    this.isSmallViewShowOnlyVideo = false,
  }) : super.internal();
}

/// picture in picture layout
class ZegoLayoutPictureInPicture extends StatefulWidget {
  const ZegoLayoutPictureInPicture({
    Key? key,
    required this.userList,
    required this.layoutConfig,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.avatarConfig,
  }) : super(key: key);

  final List<ZegoUIKitUser> userList;
  final ZegoLayoutPictureInPictureConfig layoutConfig;

  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  /// avatar etc.
  final ZegoAvatarConfig? avatarConfig;

  @override
  State<ZegoLayoutPictureInPicture> createState() =>
      _ZegoLayoutPictureInPictureState();
}

class _ZegoLayoutPictureInPictureState
    extends State<ZegoLayoutPictureInPicture> {
  late ZegoViewPosition currentPosition;

  @override
  void initState() {
    super.initState();

    currentPosition = widget.layoutConfig.smallViewPosition;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userList.length > 2) {
      return multiPIP();
    }

    return oneOnOnePIP();
  }

  Widget oneOnOnePIP() {
    final localUser = ZegoUIKit().getLocalUser();

    final largeViewUser =
        widget.userList.isNotEmpty ? widget.userList[0] : null;
    final smallViewUser =
        widget.userList.length > 1 ? widget.userList[1] : null;

    return Stack(
      children: [
        if (largeViewUser == null)
          Container()
        else
          LayoutBuilder(builder: (context, constraints) {
            return ZegoAudioVideoView(
              user: largeViewUser,
              backgroundBuilder: widget.backgroundBuilder,
              foregroundBuilder: widget.foregroundBuilder,
              avatarConfig: widget.avatarConfig,
            );
          }),
        if (smallViewUser == null)
          Container()
        else
          ZegoLayoutPIPSmallItem(
            targetUser: smallViewUser,
            localUser: localUser,
            defaultPosition: widget.layoutConfig.smallViewPosition,
            draggable: widget.layoutConfig.isSmallViewDraggable,
            showOnlyVideo: widget.layoutConfig.isSmallViewShowOnlyVideo,
            onTap: (ZegoUIKitUser? user) {
              setState(() {
                if (!widget.layoutConfig.switchLargeOrSmallViewByClick) {
                  return;
                }

                final firstUser = widget.userList[0];
                widget.userList[0] = widget.userList[1];
                widget.userList[1] = firstUser;
              });
            },
            size: widget.layoutConfig.smallViewSize,
            margin: widget.layoutConfig.margin,
            foregroundBuilder: widget.foregroundBuilder,
            backgroundBuilder: widget.backgroundBuilder,
            avatarConfig: widget.avatarConfig,
          ),
      ],
    );
  }

  Widget multiPIP() {
    final largeViewUser = widget.userList[0];
    final smallViewList = widget.userList.sublist(1);

    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return ZegoAudioVideoView(
            user: largeViewUser,
            backgroundBuilder: widget.backgroundBuilder,
            foregroundBuilder: widget.foregroundBuilder,
            avatarConfig: widget.avatarConfig,
          );
        }),
        ZegoLayoutPIPSmallItemList(
          targetUsers: smallViewList,
          defaultPosition: widget.layoutConfig.smallViewPosition,
          showOnlyVideo: false,
          scrollable: widget.layoutConfig.isSmallViewsScrollable,
          visibleItemCount: widget.layoutConfig.visibleSmallViewsCount,
          onTap: (ZegoUIKitUser clickedUser) {
            setState(() {
              if (!widget.layoutConfig.switchLargeOrSmallViewByClick) {
                return;
              }

              /// swap large view user to small view user
              final largeViewUser = widget.userList[0];
              final indexOfClickedUser = widget.userList
                  .indexWhere((user) => clickedUser.id == user.id);
              widget.userList[0] = clickedUser;
              widget.userList[indexOfClickedUser] = largeViewUser;
            });
          },
          size: widget.layoutConfig.smallViewSize,
          margin: widget.layoutConfig.margin,
          spacingBetweenSmallViews:
              widget.layoutConfig.spacingBetweenSmallViews,
          foregroundBuilder: widget.foregroundBuilder,
          backgroundBuilder: widget.backgroundBuilder,
          avatarConfig: widget.avatarConfig,
        ),
      ],
    );
  }
}
