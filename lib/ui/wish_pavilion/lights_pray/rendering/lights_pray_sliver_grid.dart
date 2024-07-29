import 'package:flutter/rendering.dart';

class LightsPrayGridDelegate extends SliverGridDelegate {
  LightsPrayGridDelegate({
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 7.0 / 6.0,
    this.length = 72,
  });

  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int length;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return LightsPrayGridLayout(
      crossAxisExtent: constraints.crossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      length: length,
    );
  }

  @override
  bool shouldRelayout(LightsPrayGridDelegate oldDelegate) {
    return mainAxisSpacing != oldDelegate.mainAxisSpacing ||
        crossAxisSpacing != oldDelegate.crossAxisSpacing;
  }
}

class LightsPrayGridLayout extends SliverGridLayout {
  LightsPrayGridLayout({
    required this.crossAxisExtent,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
    required this.length,
  })  : assert(crossAxisExtent > 0.0),
        assert(crossAxisSpacing > 0.0),
        width = (crossAxisExtent - mainAxisSpacing * 4) / 5,
        height = (crossAxisExtent - mainAxisSpacing * 4) / 5 * childAspectRatio,
        cachedGeometries = List.generate(length + 1, (index) => null);

  final double crossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  final int length;

  final double width;
  final double height;
  final List<SliverGridGeometry?> cachedGeometries;

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0 || height == 0) {
      return 0;
    }

    int rows = childCount <= 3
        ? 1
        : childCount <= 7
            ? 2
            : ((childCount - 7) / 5).ceil() + 2;

    return height * rows + crossAxisSpacing * (rows - 1);
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    SliverGridGeometry? geometry = cachedGeometries[index];
    if (geometry != null) {
      return geometry;
    }

    int rows = index <= 2
        ? 1
        : index <= 6
            ? 2
            : ((index - 6) / 5).ceil() + 2;

    int rowCount = rows == 1
        ? 3
        : rows == 2
            ? 4
            : 5;

    int rowIndex = rows == 1
        ? index
        : rows == 2
            ? index - 3
            : (index - 7) % 5;

    double x = 0.0;
    if (rows <= 2) {
      x = (crossAxisExtent -
                  width * rowCount -
                  mainAxisSpacing * (rowCount - 1)) /
              2 +
          (width + mainAxisSpacing) * rowIndex;
    } else {
      x = (width + mainAxisSpacing) * rowIndex;
    }

    geometry = SliverGridGeometry(
      scrollOffset: (height + crossAxisSpacing) * (rows - 1), // "y"
      crossAxisOffset: x, // "x"
      mainAxisExtent: height, // "height"
      crossAxisExtent: width, // "width"
    );

    cachedGeometries[index] = geometry;

    return geometry;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final int rows = scrollOffset ~/ (height + crossAxisSpacing);

    if (rows <= 1) {
      return 0;
    }
    if (rows <= 2) {
      return 3;
    }

    return (rows - 1) * 5 - 3;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int rows = scrollOffset ~/ (height + crossAxisSpacing);

    return rows * 5 - 3 - 1;
  }
}
