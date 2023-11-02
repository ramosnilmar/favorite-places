import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as Map;
    PlaceLocation location;
    bool isSelecting = true;

    if (place['location'] == null) {
      location = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
      );
    } else {
      location = place['location'];
      isSelecting = place['isSelecting'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelecting ? 'Pick your Location' : 'Your Location',
        ),
        actions: [
          if (isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            location.latitude,
            location.longitude,
          ),
          zoom: 16,
        ),
        onTap: !isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                });
              },
        markers: (_pickedLocation == null && isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        location.latitude,
                        location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
