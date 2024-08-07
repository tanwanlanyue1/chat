import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'map_controller.dart';

///地图位置选择，显示位置
class MapPage extends StatelessWidget {
  final controller = Get.put(MapController());
  final state = Get.find<MapController>().state;

  ///标题
  final String? title;

  MapPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),

    );
  }
}
