import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController extends GetxController {

  GoogleMapController? mapController;

  final initPos = CameraPosition(
    //23.11320434898468, 113.27840806963145
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void onInit() {
    super.onInit();
    Permission.location.request();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }


}
