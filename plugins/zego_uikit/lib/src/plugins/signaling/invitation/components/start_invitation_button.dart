// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';

/// @nodoc
class ZegoStartInvitationButton extends StatefulWidget {
  const ZegoStartInvitationButton({
    Key? key,
    required this.invitationType,
    required this.invitees,
    required this.data,
    this.isAdvancedMode = false,
    this.notificationConfig,
    this.timeoutSeconds = 60,
    this.text,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.iconTextSpacing,
    this.verticalLayout = true,
    this.buttonSize,
    this.borderRadius,
    this.margin,
    this.padding,
    this.onWillPressed,
    this.onPressed,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
  }) : super(key: key);
  final bool isAdvancedMode;

  final int invitationType;
  final List<String> invitees;
  final String data;
  final int timeoutSeconds;
  final ZegoNotificationConfig? notificationConfig;

  final String? text;
  final TextStyle? textStyle;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? borderRadius;
  final double? iconTextSpacing;
  final bool verticalLayout;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// start invitation if return true false will do nothing
  final Future<bool> Function()? onWillPressed;

  ///  You can do what you want after pressed.
  final void Function(
    String code,
    String message,
    String invitationID,
    List<String> errorUsers,
  )? onPressed;

  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  @override
  State<ZegoStartInvitationButton> createState() =>
      _ZegoStartInvitationButtonState();
}

/// @nodoc
class _ZegoStartInvitationButtonState extends State<ZegoStartInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: onPressed,
      text: widget.text,
      textStyle: widget.textStyle,
      icon: widget.icon,
      iconTextSpacing: widget.iconTextSpacing,
      iconSize: widget.iconSize,
      borderRadius: widget.borderRadius ?? widget.buttonSize?.width ?? 0 / 2,
      buttonSize: widget.buttonSize,
      margin: widget.margin,
      padding: widget.padding,
      verticalLayout: widget.verticalLayout,
      clickableTextColor: widget.clickableTextColor,
      unclickableTextColor: widget.unclickableTextColor,
      clickableBackgroundColor: widget.clickableBackgroundColor,
      unclickableBackgroundColor: widget.unclickableBackgroundColor,
    );
  }

  Future<void> onPressed() async {
    final canSendInvitation = await widget.onWillPressed?.call() ?? true;
    if (!canSendInvitation) {
      ZegoLoggerService.logInfo(
        'onWillPressed stop click process',
        tag: 'uikit-plugin-signaling',
        subTag: 'start invitation button',
      );

      return;
    }

    final sendResult = widget.isAdvancedMode
        ? ZegoUIKit().getSignalingPlugin().sendAdvanceInvitation(
              inviterID: ZegoUIKit().getLocalUser().id,
              inviterName: ZegoUIKit().getLocalUser().name,
              invitees: widget.invitees,
              timeout: widget.timeoutSeconds,
              type: widget.invitationType,
              data: widget.data,
              zegoNotificationConfig: widget.notificationConfig,
            )
        : ZegoUIKit().getSignalingPlugin().sendInvitation(
              inviterID: ZegoUIKit().getLocalUser().id,
              inviterName: ZegoUIKit().getLocalUser().name,
              invitees: widget.invitees,
              timeout: widget.timeoutSeconds,
              type: widget.invitationType,
              data: widget.data,
              isAdvancedMode: widget.isAdvancedMode,
              zegoNotificationConfig: widget.notificationConfig,
            );
    return sendResult.then(
      (result) {
        widget.onPressed?.call(
          result.error?.code ?? '',
          result.error?.message ?? '',
          result.invitationID,
          result.errorInvitees.keys.toList(),
        );
      },
    );
  }
}
