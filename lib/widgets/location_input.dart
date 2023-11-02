import 'dart:convert';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/utils/app_routes.dart';
import 'package:favorite_places/utils/get_place_location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectPlace});

  final Function(PlaceLocation) onSelectPlace;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGetingLocation = false;
  String apiKey = const String.fromEnvironment("apiKey");

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGetingLocation = false;
    });

    widget.onSelectPlace(_pickedLocation!);
  }

  void _getCurrentUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGetingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pikedLocation = await Navigator.of(context)
        .pushNamed<dynamic>(AppRoutes.maps, arguments: {});

    if (pikedLocation == null) {
      return;
    }
    _savePlace(pikedLocation.latitude, pikedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage(_pickedLocation!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGetingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: previewContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Current Location'),
              ),
              TextButton.icon(
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text('Select on Map'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
