

import 'package:movies_buff/models/movie.dart';

import 'movie_event.dart';

class UpdateMovie extends MovieEvent {
  Movie newMovie = Movie();
  int movieIndex = 101;

  UpdateMovie(int index, Movie movie) {
    newMovie = movie;
    movieIndex = index;
  }
}