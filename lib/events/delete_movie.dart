

import 'movie_event.dart';

class DeleteMovie extends MovieEvent {
  int movieIndex = 101;

  DeleteMovie(int index) {
    movieIndex = index;
  }
}