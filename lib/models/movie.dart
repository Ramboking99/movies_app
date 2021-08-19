

import 'package:movies_buff/db/database_provider.dart';

class Movie {
  int? id;
  String? movieName;
  String? director;
  String? moviePoster;
  bool isWatched = false;

  Movie({this.id, this.movieName = "", this.director = "", this.moviePoster = "", this.isWatched = false});

  Movie.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    movieName = map[DatabaseProvider.COLUMN_NAME];
    director = map[DatabaseProvider.COLUMN_DIRECTOR];
    moviePoster = map[DatabaseProvider.COLUMN_POSTER];
    isWatched = map[DatabaseProvider.COLUMN_WATCHED] == 1;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: movieName,
      DatabaseProvider.COLUMN_DIRECTOR: director,
      DatabaseProvider.COLUMN_POSTER: moviePoster,
      DatabaseProvider.COLUMN_WATCHED: isWatched ? 1 : 0,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }
}