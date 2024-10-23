import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'map_controller.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = Get.put(MapController());
  Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GetBuilder<MapController>(
        builder: (_){
          return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: controller.initPos,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: controller.markers,
              onTap: (val){
                print("val===$val");
              },
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              });
        },
      ),
    );
  }
}
