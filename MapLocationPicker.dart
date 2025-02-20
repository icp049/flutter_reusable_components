import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({Key? key}) : super(key: key);

  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late MapController _mapController;
  var textController = TextEditingController();
  LatLng? _currentLocation;
  LatLng? _markerPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation(); // Get the current location when the app starts
  }

  // Method to get the current location using Geolocator
  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markerPosition = _currentLocation; // Set the initial marker position to the current location
    });
    _mapController.move(_currentLocation!, 14.4746); // Move map to the user's location
  }

  // Check if location services are enabled and get the user's location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so return a default location
      return Future.error('Location services are disabled');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied, so return a default location
        return Future.error('Location permissions are denied');
      }
    }

    // If everything is good, get the position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while getting location
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentLocation,
                    zoom: 14.4746,
                    onPositionChanged: (MapPosition position, bool hasGesture) {
                      // Update the coordinates in the text field
                      setState(() {
                        _markerPosition = position.center; // Update marker position when the map moves
                      });
                      textController.text =
                          'Lat: ${position.center!.latitude.toString()}, Long: ${position.center!.longitude.toString()}';
                    },
                    onTap: (_, LatLng latlng) {
                      // Allow the user to place a custom pin when tapping the map
                      setState(() {
                        _markerPosition = latlng;
                        textController.text =
                            'Lat: ${latlng.latitude.toString()}, Long: ${latlng.longitude.toString()}';
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        if (_markerPosition != null)
                          Marker(
                            point: _markerPosition!,
                            width: 40.0,  // Width of the marker
                            height: 40.0, // Height of the marker
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.red,
                              size: 40, // Icon size
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 20,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: TextFormField(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    controller: textController,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                          fontSize: 19,
                        ),
                      ),
                      onPressed: () {
                        if (_markerPosition != null) {
                          print("Location: ${_markerPosition!.latitude}, ${_markerPosition!.longitude}");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
