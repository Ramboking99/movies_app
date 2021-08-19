


import 'package:movies_buff/models/movie.dart';

import 'movie_event.dart';

class SetWatchedMovies extends MovieEvent {
  List<Movie> movieList = List<Movie>.empty();

  SetWatchedMovies(List<Movie> movies) {
    movieList = movies;
  }
}