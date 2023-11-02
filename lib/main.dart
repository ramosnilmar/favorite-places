import 'package:favorite_places/screen/map_screen.dart';
import 'package:favorite_places/screen/place_form_screen.dart';
import 'package:favorite_places/screen/places_details_screen.dart';
import 'package:favorite_places/screen/places_list_screen.dart';
import 'package:favorite_places/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Great Places',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const PacesListScreen(),
      routes: {
        AppRoutes.placeForm: (ctx) => const PlaceFormScreen(),
        AppRoutes.placeDetails: (ctx) => const PlaceDetailsScreen(),
        AppRoutes.maps: (ctx) => const MapScreen(),
      },
    );
  }
}
