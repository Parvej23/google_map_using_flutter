import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();


  Location location = new Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {

    });

  }

  final Set<Marker> markers={};
  addMarkers(){
    markers.add(
      Marker(
          markerId: MarkerId('current-location'),
          position: LatLng(_locationData!.latitude!.toDouble(), _locationData!.longitude!.toDouble()),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'NavieaSoft'
          ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _locationData!=null?GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(_locationData!.latitude!.toDouble(), _locationData!.longitude!.toDouble()),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          addMarkers();
        },
        markers: markers,
      ):Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}