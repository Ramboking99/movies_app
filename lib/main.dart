import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_buff/bloc/movie_bloc.dart';

import 'movie_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieBloc>(
      create: (context) => MovieBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoviesBuff',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const MovieList(),
      ),
    );
  }
}