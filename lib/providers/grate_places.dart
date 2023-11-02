import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final sqlDb = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );

  return sqlDb;
}

class GratePlacesNotifier extends StateNotifier<List<Place>> {
  GratePlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
            image: File(row['image'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: copiedImage,
      location: location,
    );

    final sqlDb = await _getDatabase();

    sqlDb.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );

    state = [newPlace, ...state];
  }

  void removePlace(String id) async {
    final sqlDb = await _getDatabase();

    sqlDb.delete(
      'user_places',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((place) => place.id != id).toList();
  }
}

final gratePlacesProvider =
    StateNotifierProvider<GratePlacesNotifier, List<Place>>(
  (ref) => GratePlacesNotifier(),
);
