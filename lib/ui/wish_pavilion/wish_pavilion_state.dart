class WishPavilionState {
  List<WishPavilionItem> items = [
    WishPavilionItem(
      type: WishPavilionType.zenRoom,
      icon: "assets/images/wish_pavilion/zen_room.png",
      titleIcon: "assets/images/wish_pavilion/zen_room_title.png",
      top: 120.5,
      left: 59.0,
      width: 120.0,
      height: 117.5,
      titleTop: 117.5,
      titleLeft: 60.0,
      titleWidth: 35.0,
      titleHeight: 62.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.templeOfWealth,
      icon: "assets/images/wish_pavilion/temple_of_wealth.png",
      // titleIcon: "assets/images/wish_pavilion/temple_of_wealth_title.png",
      titleIcon: "",
      top: 197.5,
      right: 0.0,
      width: 154.5,
      height: 97.5,
      titleTop: 190.5,
      titleRight: 122.0,
      titleWidth: 36.0,
      titleHeight: 82.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.yearningRiver,
      icon: "assets/images/wish_pavilion/yearning_river.png",
      titleIcon: "assets/images/wish_pavilion/yearning_river_title.png",
      top: 298.5,
      left: 12.0,
      width: 171.0,
      height: 83.0,
      titleTop: 262.5,
      titleLeft: 23.5,
      titleWidth: 35.5,
      titleHeight: 82.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.lightsPray,
      icon: "assets/images/wish_pavilion/lights_pray.png",
      titleIcon: "assets/images/wish_pavilion/lights_pray_title.png",
      top: 326.0,
      right: 9.0,
      width: 154.5,
      height: 117.5,
      titleTop: 311.0,
      titleRight: 22.5,
      titleWidth: 35.5,
      titleHeight: 97.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.releasePond,
      icon: "assets/images/wish_pavilion/release_pond.png",
      // titleIcon: "assets/images/wish_pavilion/release_pond_title.png",
      titleIcon: "",
      top: 489.5,
      left: 48.0,
      width: 129.0,
      height: 99.0,
      titleTop: 474.5,
      titleLeft: 33.5,
      titleWidth: 35.5,
      titleHeight: 82.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.hallOfPrayer,
      icon: "assets/images/wish_pavilion/hall_of_prayer.png",
      titleIcon: "assets/images/wish_pavilion/hall_of_prayer_title.png",
      top: 510.5,
      right: 0.0,
      width: 113.0,
      height: 143.5,
      titleTop: 510.0,
      titleRight: 98.5,
      titleWidth: 35.5,
      titleHeight: 97.5,
    ),
    WishPavilionItem(
      type: WishPavilionType.wishingForest,
      icon: "assets/images/wish_pavilion/wishing_forest.png",
      // titleIcon: "assets/images/wish_pavilion/wishing_forest_title.png",
      titleIcon: "",
      top: 647.0,
      left: 55.5,
      width: 198.0,
      height: 65.0,
      titleTop: 618.5,
      titleLeft: 58.5,
      titleWidth: 35.5,
      titleHeight: 82.5,
    ),
  ];
}

enum WishPavilionType {
  zenRoom,          // 禅房
  templeOfWealth,   // 财神殿
  yearningRiver,    // 思亲河
  lightsPray,       // 供灯祈福
  releasePond,      // 放生池
  hallOfPrayer,     // 祈福殿
  wishingForest,    // 许园林
}

class WishPavilionItem {
  final WishPavilionType type;
  final String icon;
  final String titleIcon;

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  final double? titleTop;
  final double? titleLeft;
  final double? titleRight;
  final double? titleBottom;
  final double? titleWidth;
  final double? titleHeight;

  WishPavilionItem({
    required this.type,
    required this.icon,
    required this.titleIcon,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
    this.titleTop,
    this.titleLeft,
    this.titleRight,
    this.titleBottom,
    this.titleWidth,
    this.titleHeight,
  });
}
