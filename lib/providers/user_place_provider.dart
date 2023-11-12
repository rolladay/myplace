import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myplace/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBases() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    //오픈
    onCreate: (db, version) {
      return db.execute(git
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      //이니셜라이즈드... FUCK!!! I MISS ' on the Create Code.
    },
    version: 1,
  );
  return db;
}

class UserPlaceStateNotifier extends StateNotifier<List<Place>> {
  UserPlaceStateNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDataBases();
    final data = await db.query('user_places');
    //this is a map data.
    final places = data.map(
      (row) => Place(
        id: row['id'] as String,
        name: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'] as String,
        ),
      ),
    ).toList();

    state = places;
  }

  void addPlace(
      {required String title,
      required File image,
      required PlaceLocation location}) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$fileName');

    //newPath는 파일네임도 요구하기 때문에 이거 하기전에 파일네임 먼저 받아와야하는거

    final newPlace = Place(name: title, image: copiedImage, location: location);

    final db = await _getDataBases();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlaceProvider =
    StateNotifierProvider<UserPlaceStateNotifier, List<Place>>(
  (ref) => UserPlaceStateNotifier(),
);
