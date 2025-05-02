import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:favirote_plaseces/moudel/place.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'place.db'),
    onCreate: (db, version) {
      return db.execute(
        ('CREATE TABLE user_place (id TEXT PRIMARY KEY , name TEXT , image TEXT , lat REAL , lon REAL)'),
      );
    },
    version: 1,
  );

  return db;
}

class UserplaceNotifier extends StateNotifier<List<Place>> {
  UserplaceNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_place');

    final place = data
        .map(
          (item) => Place(
            id: item['id'] as String,
            name: item['name'] as String,
            image: File(item['image'] as String),
            location: PlaceLocation(
              latitude: item['lat'] as double,
              longitude: item['lon'] as double,
            ),
          ),
        )
        .toList();

    state = place;
  }

  void addpalce(String name, File image, PlaceLocation location) async {
    final appdir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedimage = await image.copy('${appdir.path}/$filename');
    final newplace = Place(name: name, image: copiedimage, location: location);

    final db = await _getDatabase();
    await db.insert(
      'user_place',
      {
        'id': newplace.id,
        'name': newplace.name,
        'image': newplace.image.path,
        'lat': newplace.location.latitude,
        'lon': newplace.location.longitude
      },
    );

    state = [newplace, ...state];
  }
}

final myplace = StateNotifierProvider<UserplaceNotifier, List<Place>>(
  (ref) => UserplaceNotifier(),
);
