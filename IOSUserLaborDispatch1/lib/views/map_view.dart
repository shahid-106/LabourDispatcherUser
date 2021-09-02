import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {

  var lat, long;
  MapView({this.lat, this.long});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  Set<Marker> _markers = new Set();
  bool isLoading = true;
  var currentLocation;

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  Future<void> goToTheLocation() async {
    final CameraPosition loc = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(widget.lat, widget.long),
        // tilt: 59.440717697143555,
        zoom: 16);
    createMarker();
    mapController.animateCamera(CameraUpdate.newCameraPosition(loc));
  }

  createMarker(){
    _markers = new Set();
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: LatLng(widget.lat, widget.long),
      infoWindow: InfoWindow(
        title: 'Current Location',
        snippet: '*',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  getLocation() async {
    try {
      createMarker();
      isLoading = false;
      setState(() { });
    } on Exception {
      currentLocation = null;
    }
  }

  @override
  void dispose(){
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    goToTheLocation();

    return Scaffold(
      body: SafeArea(
        child: isLoading ? Loader() : GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          initialCameraPosition:
          CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 16),
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          markers: _markers,
          myLocationButtonEnabled: true,
        )
      )
    );
  }
}
