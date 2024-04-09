import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapid_app/data/service/location_service/location_service.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';

class LocationController extends RapidController {
  dynamic arguments = Get.arguments;
  RxDouble latitude = 11.254476665026774.obs;
  RxDouble longitude = 75.83699992528449.obs;
  late Position position;
  late CameraPosition initialCameraPosition;
  RxSet<Marker> marker = RxSet(<Marker>{});
  late LatLng sourcePosition;
  final Completer<GoogleMapController> mapController = Completer();
  RxString location = ''.obs;

  @override
  void onInit() {
    initialCameraPosition = CameraPosition(
        target: LatLng(latitude.value, longitude.value), zoom: 13);
    currentLocation();
    super.onInit();
  }

  void showLocationPins() async {
    sourcePosition = LatLng(latitude.value, longitude.value);

    marker.add(Marker(
        markerId: const MarkerId('sourcePosition'),
        position: sourcePosition,
        icon: BitmapDescriptor.defaultMarker));
  }

  // Future<void> setCustomMapPin() async {
  //   sourceIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(size: Size(50, 50)),
  //       'assets/icons/marker.png');
  // }

  Future<void> currentLocation() async {
    if (arguments != null) {
      latitude.value = double.parse(arguments['latitude']);
      longitude.value = double.parse(arguments['longitude']);
    } else {
      await getCurrentLocation();
    }
  }

  ///getting current latitude and longitude
  Future<void> getCurrentLocation() async {
    position = await LocationService().getUserCurrentLocation();
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    sourcePosition = LatLng(latitude.value, longitude.value);
    initialCameraPosition = CameraPosition(
      target: LatLng(latitude.value, longitude.value),
      zoom: 5,
    );
    marker.add(Marker(
        markerId: const MarkerId('sourcePosition'),
        position: LatLng(latitude.value, longitude.value),
        icon: BitmapDescriptor.defaultMarker));
    location.value = '${latitude.value.toString()},${longitude.value.toString()}';
  }

  void mapLocationUpdate(LatLng latLng) async {
    latitude.value = latLng.latitude;
    longitude.value = latLng.longitude;
    initialCameraPosition = CameraPosition(
        target: LatLng(latitude.value,
            longitude.value),
        zoom: 13.0);
    sourcePosition = latLng;
    marker.removeWhere(
            (marker) => marker.mapsId.value == 'sourcePosition');
    final GoogleMapController gController =
    await mapController.future;
    gController.animateCamera(CameraUpdate.newCameraPosition(
        initialCameraPosition));

    marker.add(Marker(
        markerId: const MarkerId('sourcePosition'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker));
    location.value = '${latitude.value.toString()},${longitude.value.toString()}';
  }

}
