class MinePermissionsState {
  List<MinePermissionsItem> items = [];
}

enum MinePermissionsItemType {
  photos,
  camera,
  storage,
  notification,
}

class MinePermissionsItem {
  final String icon;
  final String title;
  final String detail;
  final MinePermissionsItemType type;
  bool isOpen;

  MinePermissionsItem({
    required this.icon,
    required this.title,
    required this.detail,
    required this.type,
    this.isOpen = false,
  });
}
