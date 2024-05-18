import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final Completer<GoogleMapController> controller;
  // Completer<GoogleMapController>();
  const MapSample({super.key, required this.controller});
  @override
  State<MapSample> createState() => MapSampleState(controller: this.controller);
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> controller;
  MapSampleState({required this.controller});

  Future<void> updateCameraPosition(cameraPosition) async {
    final GoogleMapController controller = await this.controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          this.controller.complete(controller);
        },
      ),
    );
  }
}
