


import 'package:movies_buff/models/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_MOVIE = "movie";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_DIRECTOR = "director";
  static const String COLUMN_POSTER = "poster";
  static const String COLUMN_WATCHED = "isWatched";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database? _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database ?? await createDatabase();
    }

    _database = await createDatabase();
    return _database ?? await createDatabase();
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'movieDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating movie table");

        await database.execute(
          "CREATE TABLE $TABLE_MOVIE ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_DIRECTOR TEXT,"
              "$COLUMN_POSTER TEXT,"
              "$COLUMN_WATCHED INTEGER"
              ")",
        );
      },
    );
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;

    var movies = await db
        .query(TABLE_MOVIE, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_DIRECTOR, COLUMN_POSTER, COLUMN_WATCHED]);

    List<Movie> movieList = List<Movie>.empty();

    movies.forEach((currentFood) {
      Movie movie = Movie.fromMap(currentFood);

      movieList.add(movie);
    });

    return movieList;
  }

  Future<List<Movie>> getWatchedMovies() async {
    final db = await database;

    var watchedMovies = await db
        .rawQuery('SELECT * FROM $TABLE_MOVIE WHERE $COLUMN_WATCHED = ?', [1]);

    List<Movie> movieList = List<Movie>.empty();

    watchedMovies.forEach((currentFood) {
      Movie movie = Movie.fromMap(currentFood);

      movieList.add(movie);
    });

    return movieList;
  }

  Future<Movie> insert(Movie movie) async {
    final db = await database;
    movie.id = await db.insert(TABLE_MOVIE, movie.toMap());
    print(movie.id);
    return movie;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_MOVIE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Movie movie) async {
    final db = await database;

    return await db.update(
      TABLE_MOVIE,
      movie.toMap(),
      where: "id = ?",
      whereArgs: [movie.id],
    );
  }
}