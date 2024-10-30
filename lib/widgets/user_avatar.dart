import 'package:flutter/material.dart';

import 'app_image.dart';

///用户头像
class UserAvatar extends StatelessWidget {
  final String url;
  final double size;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const UserAvatar._({
    super.key,
    required this.url,
    required this.size,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  factory UserAvatar(
    String url, {
    Key? key,
    required double size,
    BorderRadius? borderRadius,
  }) =>
      UserAvatar._(
        key: key,
        url: url,
        size: size,
        borderRadius: borderRadius,
      );

  factory UserAvatar.circle(
    String url, {
    Key? key,
    required double size,
  }) =>
      UserAvatar._(
        key: key,
        url: url,
        size: size,
        shape: BoxShape.circle,
      );

  @override
  Widget build(BuildContext context) {
    return AppImage.network(
      url,
      width: size,
      height: size,
      borderRadius: borderRadius,
      shape: shape,
      fit: BoxFit.cover,
      placeholder: buildPlaceholder(),
    );
  }

  Widget buildPlaceholder() {
    Widget child = AppImage.asset(
      'assets/images/common/default_avatar.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
    if (shape == BoxShape.circle) {
      return ClipOval(
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }
    return child;
  }
}
