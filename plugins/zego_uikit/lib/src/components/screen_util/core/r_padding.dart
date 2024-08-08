// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Project imports:
import 'package:zego_uikit/src/components/screen_util/core/size_extension.dart';

/// @nodoc
class ZegoRPadding extends SingleChildRenderObjectWidget {
  /// Creates a adapt widget that insets its child.
  ///
  /// The [padding] argument must not be null.
  const ZegoRPadding({
    Key? key,
    required Widget child,
    required this.padding,
  }) : super(key: key, child: child);

  /// The amount of space by which to inset the child.
  final EdgeInsets padding;

  @override
  RenderPadding createRenderObject(BuildContext context) {
    return RenderPadding(
      padding: padding is ZegoREdgeInsets ? padding : padding.zR,
      textDirection: Directionality.maybeOf(context),
    );
  }
}

/// @nodoc
class ZegoREdgeInsets extends EdgeInsets {
  /// Creates adapt insets from offsets from the left, top, right, and bottom.
  ZegoREdgeInsets.fromLTRB(double left, double top, double right, double bottom)
      : super.fromLTRB(left.zR, top.zR, right.zR, bottom.zR);

  /// Creates adapt insets where all the offsets are `value`.
  ///
  /// {@tool snippet}
  ///
  /// Adapt height-pixel margin on all sides:
  ///
  /// ```dart
  /// const REdgeInsets.all(8.0)
  /// ```
  /// {@end-tool}
  ZegoREdgeInsets.all(double value) : super.all(value.zR);

  /// Creates adapt insets with symmetrical vertical and horizontal offsets.
  ///
  /// {@tool snippet}
  ///
  /// Adapt Eight pixel margin above and below, no horizontal margins:
  ///
  /// ```dart
  /// const REdgeInsets.symmetric(vertical: 8.0)
  /// ```
  /// {@end-tool}
  ZegoREdgeInsets.symmetric({
    double vertical = 0,
    double horizontal = 0,
  }) : super.symmetric(vertical: vertical.zR, horizontal: horizontal.zR);

  /// Creates adapt insets with only the given values non-zero.
  ///
  /// {@tool snippet}
  ///
  /// Adapt left margin indent of 40 pixels:
  ///
  /// ```dart
  /// const REdgeInsets.only(left: 40.0)
  /// ```
  /// {@end-tool}
  ZegoREdgeInsets.only({
    double bottom = 0,
    double right = 0,
    double left = 0,
    double top = 0,
  }) : super.only(
          bottom: bottom.zR,
          right: right.zR,
          left: left.zR,
          top: top.zR,
        );
}

/// @nodoc
class ZegoREdgeInsetsDirectional extends EdgeInsetsDirectional {
  /// Creates insets where all the offsets are `value`.
  ///
  /// {@tool snippet}
  ///
  /// Adapt eight-pixel margin on all sides:
  ///
  /// ```dart
  /// const REdgeInsetsDirectional.all(8.0)
  /// ```
  /// {@end-tool}
  ZegoREdgeInsetsDirectional.all(double value) : super.all(value.zR);

  /// Creates insets with only the given values non-zero.
  ///
  /// {@tool snippet}
  ///
  /// Adapt margin indent of 40 pixels on the leading side:
  ///
  /// ```dart
  /// const REdgeInsetsDirectional.only(start: 40.0)
  /// ```
  /// {@end-tool}
  ZegoREdgeInsetsDirectional.only({
    double bottom = 0,
    double end = 0,
    double start = 0,
    double top = 0,
  }) : super.only(
          bottom: bottom.zR,
          start: start.zR,
          end: end.zR,
          top: top.zR,
        );

  /// Creates adapt insets from offsets from the start, top, end, and bottom.
  ZegoREdgeInsetsDirectional.fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) : super.fromSTEB(
          start.zR,
          top.zR,
          end.zR,
          bottom.zR,
        );
}
