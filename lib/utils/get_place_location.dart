import 'package:favorite_places/model/place.dart';

String locationImage(PlaceLocation placeLocation) {
  String apiKey = const String.fromEnvironment("apiKey");
  final lat = placeLocation.latitude;
  final lng = placeLocation.longitude;

  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
}
