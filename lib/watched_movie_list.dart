


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_buff/events/set_watched_movies.dart';

import 'bloc/movie_bloc.dart';
import 'db/database_provider.dart';
import 'events/delete_movie.dart';
import 'events/update_movie.dart';
import 'models/movie.dart';
import 'movie_form.dart';
import 'movie_page.dart';

class WatchedMovieList extends StatefulWidget {
  const WatchedMovieList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WatchedMovieListState();
}

class _WatchedMovieListState extends State<WatchedMovieList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getWatchedMovies().then(
          (movieList) {
        print(movieList);
        BlocProvider.of<MovieBloc>(context).add(SetWatchedMovies(movieList));
      },
    );
  }

  showMovieDialog(BuildContext context, Movie movie, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${movie.movieName}"),
        content: Text("Director: ${movie.director}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MovieForm(movie: movie, movieIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(movie.id ?? 101).then((_) {
              BlocProvider.of<MovieBloc>(context).add(
                DeleteMovie(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire movie list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("MOVIESBUFF"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<MovieBloc, List<Movie>>(
          builder: (context, movieList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("movieList: $movieList");

                Movie movie = movieList[index];
                return Card(
                  child: ListTile(
                    tileColor: Colors.white,
                    contentPadding: EdgeInsets.all(16),
                    leading: Image.file(File(movie.moviePoster ?? ""), width: 100, height: 100,),
                    //     : SizedBox(
                    //   height: 30,
                    //   width: 30,
                    //   child: Image.asset("assets/images/MoviePosterDefault.jpg",fit: BoxFit.contain,),
                    // ),
                    title: Text(movie.movieName ?? "", style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Director: ${movie.director}",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      onPressed: () => showMovieDialog(context, movie, index),
                    ),
                    onTap: () {
                      setState(() {
                        Movie updatedMovie = Movie(
                          id: movie.id,
                          movieName: movie.movieName,
                          director: movie.director,
                          moviePoster: movie.moviePoster,
                          isWatched: true,
                        );

                        DatabaseProvider.db.update(updatedMovie).then(
                              (storedMovie) =>
                              BlocProvider.of<MovieBloc>(context).add(
                                UpdateMovie(updatedMovie.id ?? 101, updatedMovie),
                              ),
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MoviePage(movie: movie)));
                      });
                    },
                  ),
                );
              },
              itemCount: movieList.length,
            );
          },
          listener: (BuildContext context, movieList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MovieForm(movie: Movie()),),
        ),
      ),
    );
  }
}