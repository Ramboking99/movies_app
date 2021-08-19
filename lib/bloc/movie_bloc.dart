


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_buff/events/add_movie.dart';
import 'package:movies_buff/events/delete_movie.dart';
import 'package:movies_buff/events/movie_event.dart';
import 'package:movies_buff/events/set_movies.dart';
import 'package:movies_buff/events/set_watched_movies.dart';
import 'package:movies_buff/events/update_movie.dart';
import 'package:movies_buff/models/movie.dart';

class MovieBloc extends Bloc<MovieEvent, List<Movie>> {
  @override
  List<Movie> get initialState => List<Movie>.empty();

  MovieBloc() : super(List<Movie>.empty());

  @override
  Stream<List<Movie>> mapEventToState(MovieEvent event) async* {
    if (event is SetMovies) {
      yield event.movieList;
    } else if(event is SetWatchedMovies) {
      yield event.movieList;
    }
    else if (event is AddMovie) {
      List<Movie> newState = List.from(state);
      if (event.newMovie != null) {
        newState.add(event.newMovie ?? Movie());
      }
      yield newState;
    } else if (event is DeleteMovie) {
      List<Movie> newState = List.from(state);
      newState.removeAt(event.movieIndex);
      yield newState;
    } else if (event is UpdateMovie) {
      List<Movie> newState = List.from(state);
      newState[event.movieIndex] = event.newMovie;
      yield newState;
    }
  }
}