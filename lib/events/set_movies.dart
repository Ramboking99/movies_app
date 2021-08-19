

import 'package:movies_buff/models/movie.dart';

import 'movie_event.dart';

class SetMovies extends MovieEvent {
  List<Movie> movieList = List<Movie>.empty();

  SetMovies(List<Movie> movies) {
    movieList = movies;
  }
}