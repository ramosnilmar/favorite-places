import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/utils/app_routes.dart';
import 'package:favorite_places/utils/get_place_location.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Hero(
            tag: place.id,
            child: Image.file(
              place.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.maps,
                      arguments: {
                        'location': place.location,
                        'isSelecting': false
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        NetworkImage(locationImage(place.location)),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(place.location.address!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
