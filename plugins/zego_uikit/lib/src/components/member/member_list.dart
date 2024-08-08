// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/src/components/audio_video/camera_state_icon.dart';
import 'package:zego_uikit/src/components/audio_video/microphone_state_icon.dart';
import 'package:zego_uikit/src/components/defines.dart';
import 'package:zego_uikit/src/components/internal/internal.dart';
import 'package:zego_uikit/src/components/screen_util/screen_util.dart';
import 'package:zego_uikit/src/services/services.dart';

/// Type definition for builder of custom member list item view.
typedef ZegoMemberListItemBuilder = Widget Function(
  BuildContext context,
  Size size,
  ZegoUIKitUser user,
  Map<String, dynamic> extraInfo,
);

/// sort
typedef ZegoMemberListSorter = List<ZegoUIKitUser> Function(
  ZegoUIKitUser localUser,
  List<ZegoUIKitUser> remoteUsers,
);

class ZegoMemberList extends StatefulWidget {
  final bool showMicrophoneState;
  final bool showCameraState;
  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoMemberListItemBuilder? itemBuilder;
  final ZegoMemberListSorter? sortUserList;
  final List<String> hiddenUserIDs;
  final Stream<List<ZegoUIKitUser>>? stream;
  final List<ZegoUIKitUser> pseudoUsers;

  const ZegoMemberList({
    Key? key,
    this.showMicrophoneState = true,
    this.showCameraState = true,
    this.avatarBuilder,
    this.itemBuilder,
    this.sortUserList,
    this.stream,
    this.pseudoUsers = const [],
    this.hiddenUserIDs = const <String>[],
  }) : super(key: key);

  @override
  State<ZegoMemberList> createState() => _ZegoCallMemberListState();
}

class _ZegoCallMemberListState extends State<ZegoMemberList> {
  var usersNotifier = ValueNotifier<List<ZegoUIKitUser>>([]);
  StreamSubscription<dynamic>? userListSubscription;

  @override
  void initState() {
    super.initState();

    usersNotifier.value = List.from(widget.pseudoUsers)
      ..addAll(
        ZegoUIKit().getAllUsers(),
      );
    userListSubscription = (widget.stream ?? ZegoUIKit().getUserListStream())
        .listen(onUserListUpdated);
  }

  @override
  void dispose() {
    super.dispose();

    userListSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ZegoUIKitUser>>(
      valueListenable: usersNotifier,
      builder: (context, tempUsers, child) {
        final remoteUsers = List<ZegoUIKitUser>.from(tempUsers.reversed)
          ..removeWhere((user) => user.id == ZegoUIKit().getLocalUser().id);

        if (widget.hiddenUserIDs.isNotEmpty) {
          remoteUsers
              .removeWhere((user) => widget.hiddenUserIDs.contains(user.id));
        }

        final users = widget.sortUserList
                ?.call(ZegoUIKit().getLocalUser(), remoteUsers) ??
            [ZegoUIKit().getLocalUser(), ...remoteUsers];
        final itemSize = Size(750.zW, 72.zH);
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 48.zR),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ValueListenableBuilder(
              valueListenable: ZegoUIKitUserPropertiesNotifier(user),
              builder: (context, _, __) {
                return widget.itemBuilder?.call(context, itemSize, user, {}) ??
                    listItem(context, itemSize, user);
              },
            );
          },
        );
      },
    );
  }

  Widget listItem(BuildContext context, Size itemSize, ZegoUIKitUser user) {
    final userName = ZegoUIKit().getLocalUser().id == user.id
        ? '${user.name} (You)'
        : user.name;
    return Container(
      margin: EdgeInsets.only(bottom: 36.zR),
      child: Row(
        children: [
          SizedBox(width: 36.zR),
          avatarItem(context, user, widget.avatarBuilder),
          SizedBox(width: 20.zR),
          userNameItem(userName),
          const Expanded(child: SizedBox()),
          if (widget.showMicrophoneState)
            ZegoMicrophoneStateIcon(
                targetUser: user,
                iconMicrophoneOn:
                    UIKitImage.asset(StyleIconUrls.memberMicNormal),
                iconMicrophoneOff: UIKitImage.asset(StyleIconUrls.memberMicOff),
                iconMicrophoneSpeaking:
                    UIKitImage.asset(StyleIconUrls.memberMicSpeaking))
          else
            Container(),
          if (widget.showCameraState)
            ZegoCameraStateIcon(
              targetUser: user,
              iconCameraOn: UIKitImage.asset(StyleIconUrls.memberCameraNormal),
              iconCameraOff: UIKitImage.asset(StyleIconUrls.memberCameraOff),
            )
          else
            Container(),
          SizedBox(width: 34.zR)
        ],
      ),
    );
  }

  void onUserListUpdated(List<ZegoUIKitUser> users) {
    ZegoLoggerService.logInfo(
      'user list update:$users',
      tag: 'uikit-component',
      subTag: 'member list',
    );
    usersNotifier.value = users;
  }
}

Widget userNameItem(String name) {
  return Text(
    name,
    style: TextStyle(
      fontSize: 32.0.zR,
      color: const Color(0xffffffff),
      decoration: TextDecoration.none,
    ),
  );
}

Widget avatarItem(
  BuildContext context,
  ZegoUIKitUser user,
  ZegoAvatarBuilder? builder,
) {
  return Container(
    width: 72.zR,
    height: 72.zR,
    decoration:
        const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
    child: Center(
      child: ValueListenableBuilder(
        valueListenable: ZegoUIKitUserPropertiesNotifier(user),
        builder: (context, _, __) {
          return builder?.call(context, Size(72.zR, 72.zR), user, {}) ??
              Text(
                user.name.isNotEmpty ? user.name.characters.first : '',
                style: TextStyle(
                  fontSize: 32.0.zR,
                  color: const Color(0xff222222),
                  decoration: TextDecoration.none,
                ),
              );
        },
      ),
    ),
  );
}
