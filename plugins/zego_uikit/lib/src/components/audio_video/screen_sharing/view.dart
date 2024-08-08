// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:native_device_orientation/native_device_orientation.dart';

// Project imports:
import 'package:zego_uikit/src/components/components.dart';
import 'package:zego_uikit/src/components/internal/internal.dart';
import 'package:zego_uikit/src/services/services.dart';

const isScreenSharingExtraInfoKey = 'isScreenSharing';

/// display user screensharing information,
/// and z order of widget(from bottom to top) is:
/// 1. background view
/// 2. screen sharing view
/// 3. foreground view
class ZegoScreenSharingView extends StatefulWidget {
  const ZegoScreenSharingView({
    Key? key,
    required this.user,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.borderRadius,
    this.borderColor = const Color(0xffA4A4A4),
    this.extraInfo = const {},
    this.showFullscreenModeToggleButtonRules =
        ZegoShowFullscreenModeToggleButtonRules.showWhenScreenPressed,
    this.controller,
  }) : super(key: key);

  final ZegoUIKitUser? user;

  /// foreground builder, you can display something you want on top of the view,
  /// foreground will always show
  final ZegoAudioVideoViewForegroundBuilder? foregroundBuilder;

  /// background builder, you can display something when user close camera
  final ZegoAudioVideoViewBackgroundBuilder? backgroundBuilder;

  final double? borderRadius;
  final Color borderColor;
  final Map<String, dynamic> extraInfo;

  final ZegoShowFullscreenModeToggleButtonRules
      showFullscreenModeToggleButtonRules;
  final ZegoScreenSharingViewController? controller;

  @override
  State<ZegoScreenSharingView> createState() => _ZegoScreenSharingViewState();
}

class _ZegoScreenSharingViewState extends State<ZegoScreenSharingView> {
  ValueNotifier<bool> isShowFullScreenButtonNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return circleBorder(
      child: GestureDetector(
        child: AbsorbPointer(
          absorbing: false,
          child: Stack(
            children: [
              background(),
              if (widget.user?.id == ZegoUIKit().getLocalUser().id)
                Container()
              else
                videoView(),
              foreground(),
              fullScreenButton(),
            ],
          ),
        ),
        onTap: () {
          if (!isShowFullScreenButtonNotifier.value) {
            isShowFullScreenButtonNotifier.value = true;
            Future.delayed(const Duration(seconds: 3), () {
              isShowFullScreenButtonNotifier.value = false;
            });
          }
        },
      ),
    );
  }

  Widget videoView() {
    if (widget.user == null) {
      return Container(color: Colors.transparent);
    }

    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ValueListenableBuilder<Widget?>(
            valueListenable: ZegoUIKit().getAudioVideoViewNotifier(
              widget.user!.id,
              streamType: ZegoStreamType.screenSharing,
            ),
            builder: (context, userView, _) {
              if (userView == null) {
                /// hide view when use not found
                return Container(color: Colors.transparent);
              }

              return StreamBuilder(
                stream: NativeDeviceOrientationCommunicator()
                    .onOrientationChanged(),
                builder: (context,
                    AsyncSnapshot<NativeDeviceOrientation> asyncResult) {
                  if (asyncResult.hasData) {
                    /// Do not update ui when ui is building !!!
                    /// use postFrameCallback to update videoSize
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ///  notify sdk to update video render orientation
                      ZegoUIKit().updateAppOrientation(
                        deviceOrientationMap(asyncResult.data!),
                      );
                    });
                  }

                  return userView;
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget background() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: ZegoUIKitUserPropertiesNotifier(
                widget.user ?? ZegoUIKitUser.empty(),
              ),
              builder: (context, _, __) {
                return widget.backgroundBuilder?.call(
                      context,
                      Size(constraints.maxWidth, constraints.maxHeight),
                      widget.user,
                      {
                        ZegoViewBuilderMapExtraInfoKey.isScreenSharingView.name:
                            true,
                        ...widget.extraInfo
                      },
                    ) ??
                    Container(color: Colors.red);
              },
            ),
          ],
        );
      },
    );
  }

  Widget foreground() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: userName(context, constraints),
            ),
            localScreenShareTipView(),
            ValueListenableBuilder(
              valueListenable: ZegoUIKitUserPropertiesNotifier(
                widget.user ?? ZegoUIKitUser.empty(),
              ),
              builder: (context, _, __) {
                return widget.foregroundBuilder?.call(
                      context,
                      Size(constraints.maxWidth, constraints.maxHeight),
                      widget.user,
                      {
                        ZegoViewBuilderMapExtraInfoKey.isScreenSharingView.name:
                            true,
                        ZegoViewBuilderMapExtraInfoKey.isFullscreen.text:
                            widget.controller?.fullscreenUserNotifier.value !=
                                null,
                        ...widget.extraInfo
                      },
                    ) ??
                    Container();
              },
            ),
          ],
        ),
      );
    });
  }

  Widget userName(BuildContext context, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Text(
              widget.user?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24.0.zR,
                color: const Color(0xffffffff),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget localScreenShareTipView() {
    final tipView = widget.user?.id == ZegoUIKit().getLocalUser().id
        ? Container(
            color: const Color(0x00242736),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You are sharing screen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.zR,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.zR)),
                  OutlinedButton(
                    onPressed: () {
                      ZegoUIKit.instance.stopSharingScreen();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(73, 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.zR),
                      ),
                      side: BorderSide(width: 2.zR, color: Colors.red),
                    ),
                    child: Text(
                      'Stop sharing',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 26.zR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();

    return ValueListenableBuilder<bool>(
      valueListenable: ZegoUIKit().getScreenSharingStateNotifier(),
      builder: (context, isScreenSharing, _) {
        if (isScreenSharing &&
            widget.user?.id == ZegoUIKit().getLocalUser().id) {
          // if is sharing screen with is yourself audiovideoview show tip
          return tipView;
        }
        return Container();
      },
    );
  }

  Widget circleBorder({required Widget child}) {
    if (widget.borderRadius == null) {
      return child;
    }

    final decoration = BoxDecoration(
      border: Border.all(color: widget.borderColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
    );

    return Container(
      decoration: decoration,
      child: PhysicalModel(
        color: widget.borderColor,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
        clipBehavior: Clip.antiAlias,
        elevation: 6.0,
        shadowColor: widget.borderColor.withOpacity(0.3),
        child: child,
      ),
    );
  }

  Widget fullScreenButton() {
    switch (widget.showFullscreenModeToggleButtonRules) {
      case ZegoShowFullscreenModeToggleButtonRules.alwaysShow:
        return Positioned(
          top: 100.zR,
          right: 50.zR,
          child: getFullScreenIconButton(),
        );
      case ZegoShowFullscreenModeToggleButtonRules.alwaysHide:
        return Container();
      case ZegoShowFullscreenModeToggleButtonRules.showWhenScreenPressed:
        return ValueListenableBuilder<bool>(
          valueListenable: isShowFullScreenButtonNotifier,
          builder: (context, isShow, _) {
            if (isShow) {
              return Positioned(
                top: 120.zR,
                right: 10.zR,
                child: getFullScreenIconButton(),
              );
            } else {
              return Container();
            }
          },
        );
    }
  }

  IconButton getFullScreenIconButton() {
    return IconButton(
      icon: getFullScreenIcon(),
      onPressed: () {
        if (widget.user?.id ==
            widget.controller?.fullscreenUserNotifier.value?.id) {
          widget.controller?.fullscreenUserNotifier.value = null;
        } else {
          widget.controller?.fullscreenUserNotifier.value = widget.user;
        }
      },
    );
  }

  Image getFullScreenIcon() {
    if (widget.controller?.fullscreenUserNotifier.value?.id ==
        widget.user?.id) {
      return UIKitImage.asset(StyleIconUrls.iconVideoViewFullScreenClose);
    } else {
      return UIKitImage.asset(StyleIconUrls.iconVideoViewFullScreenOpen);
    }
  }
}
