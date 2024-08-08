// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';

/// @nodoc
class ZegoRefuseInvitationButton extends StatefulWidget {
  const ZegoRefuseInvitationButton({
    Key? key,
    required this.inviterID,
    this.isAdvancedMode = false,
    this.targetInvitationID,
    this.data,
    this.text,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.iconTextSpacing,
    this.verticalLayout = true,
    this.onPressed,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
  }) : super(key: key);
  final bool isAdvancedMode;

  final String inviterID;
  final String? targetInvitationID;
  final String? data;

  final String? text;
  final TextStyle? textStyle;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;
  final bool verticalLayout;

  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  ///  You can do what you want after pressed.
  final void Function(String code, String message)? onPressed;

  @override
  State<ZegoRefuseInvitationButton> createState() =>
      _ZegoRefuseInvitationButtonState();
}

/// @nodoc
class _ZegoRefuseInvitationButtonState
    extends State<ZegoRefuseInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: onPressed,
      text: widget.text,
      textStyle: widget.textStyle,
      icon: widget.icon,
      iconTextSpacing: widget.iconTextSpacing,
      iconSize: widget.iconSize,
      buttonSize: widget.buttonSize,
      verticalLayout: widget.verticalLayout,
      clickableTextColor: widget.clickableTextColor ?? Colors.white,
      unclickableTextColor: widget.unclickableTextColor,
      clickableBackgroundColor: widget.clickableBackgroundColor,
      unclickableBackgroundColor: widget.unclickableBackgroundColor,
    );
  }

  Future<void> onPressed() async {
    final result = widget.isAdvancedMode
        ? await ZegoUIKit().getSignalingPlugin().refuseAdvanceInvitation(
              inviterID: widget.inviterID,
              data: widget.data ?? '',
              invitationID: widget.targetInvitationID,
            )
        : await ZegoUIKit().getSignalingPlugin().refuseInvitation(
              inviterID: widget.inviterID,
              data: widget.data ?? '',
              targetInvitationID: widget.targetInvitationID,
            );

    widget.onPressed?.call(
      result.error?.code ?? '',
      result.error?.message ?? '',
    );
  }
}
