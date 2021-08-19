

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies_buff/models/movie.dart';

class MoviePage extends StatefulWidget {

  final Movie movie;

  const MoviePage({Key? key, required this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>{

  String _movieName = "";
  String _director = "";
  String _moviePoster = "";
  bool _isWatched = true;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _movieName = widget.movie.movieName ?? "";
      _director = widget.movie.director ?? "";
      _moviePoster = widget.movie.moviePoster ?? "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MOVIE"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(File(_moviePoster), width: double.infinity, height: 350,),
            //     : SizedBox(
            //   height: 350,
            //   width: double.infinity,
            //   child: Image.asset("assets/images/MoviePosterDefault.jpg",fit: BoxFit.contain,),
            // )
            const SizedBox(
              height: 20,
            ),
            Text(
              _movieName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _director,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}