import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapid_app/data/module/subpage/location_widget/location_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/app_bar_widget.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: Text(
          '',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leadingIcon: Icons.arrow_back,
        onTapLeadingIcon: _backPress,
      ),
      body: const _BodyWidget(),
    );
  }

  void _backPress() {
    Get.back(result: {
      'LOCATION': controller.location.value,
    });
  }
}

class _BodyWidget extends GetView<LocationController> {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Obx(() => GoogleMap(
                initialCameraPosition: controller.initialCameraPosition,
                mapType: MapType.normal,
                markers: controller.marker,
                onMapCreated: (GoogleMapController _controller) {
                  controller.mapController.complete(_controller);
                  controller.showLocationPins();
                },
                onTap: (LatLng latLng) =>
                    controller.mapLocationUpdate(latLng))),
          )
        ],
      ),
    );
  }
}
