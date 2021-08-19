import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_buff/events/update_movie.dart';
import 'package:movies_buff/movie_list.dart';
import 'bloc/movie_bloc.dart';
import 'db/database_provider.dart';
import 'events/add_movie.dart';
import 'models/movie.dart';

class MovieForm extends StatefulWidget {

  final Movie movie;
  final movieIndex;

  const MovieForm({Key? key, required this.movie, this.movieIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieFormState();

}

class _MovieFormState extends State<MovieForm> {

  String _movieName = "";
  String _director = "";
  String _moviePoster = "";
  bool _isWatched = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName () {
    return TextFormField(
      initialValue: _movieName,
      decoration: const InputDecoration(
        labelText: "Movie Name",
      ),
      maxLength: 15,
      style: const TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value == null) {
          return 'Movie Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _movieName = value ?? "";
      },
    );
  }

  Widget _buildDirName() {
    return TextFormField(
      initialValue: _director,
      decoration: const InputDecoration(labelText: 'Director Name'),
      style: const TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value == null) {
          return 'Director Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _director = value ?? "";
      },
    );
  }

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
      appBar: AppBar(title: Text("Movie Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildDirName(),
              SizedBox(height: 40),
              picPicker(_moviePoster, (file) => {
                setState(
                      () {
                    _moviePoster = file.path;
                  },
                )
              },
              ),
              const SizedBox(height: 20),
              widget.movie.id == null ? RaisedButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  _formKey.currentState!.save();

                  Movie movie = Movie(
                    movieName: _movieName,
                    director: _director,
                    moviePoster: _moviePoster,
                    isWatched: _isWatched,
                  );

                  DatabaseProvider.db.insert(movie).then(
                        (storedMovie) =>
                        BlocProvider.of<MovieBloc>(context).add(
                          AddMovie(storedMovie),
                        ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState!.save();

                      Movie movie = Movie(
                        movieName: _movieName,
                        director: _director,
                        moviePoster: _moviePoster,
                        isWatched: _isWatched,
                      );

                      DatabaseProvider.db.update(widget.movie).then(
                            (storedMovie) =>
                            BlocProvider.of<MovieBloc>(context).add(
                              UpdateMovie(widget.movieIndex, movie),
                            ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget picPicker(String fileName, Function onFilePicked) {
    Future<PickedFile?> _imageFile;
    ImagePicker _picker = new ImagePicker();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.image, size: 35.0,),
                onPressed: () {
                  _imageFile = _picker.getImage(source: ImageSource.gallery);
                  _imageFile.then((file) async => onFilePicked(file));
                },
              ),
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                icon: Icon(Icons.camera, size: 35.0,),
                onPressed: () {
                  _imageFile = _picker.getImage(source: ImageSource.camera);
                  _imageFile.then((file) async => onFilePicked(file));
                },
              ),
            ),
          ],
        ),
        (fileName!=null && fileName!="") ? Image.file(File(fileName), width: 300, height: 300,) : Container(width: 300, height: 300,),
      ],
    );
  }
}