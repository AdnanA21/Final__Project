import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db_app/src/bloc/moviedetailbloc/movie_detail_bloc.dart';
import 'package:movie_db_app/src/bloc/moviedetailbloc/movie_detail_event.dart';
import 'package:movie_db_app/src/bloc/moviedetailbloc/movie_detail_state.dart';
import 'package:movie_db_app/src/model/cast_list.dart';
import 'package:movie_db_app/src/model/movie.dart';
import 'package:movie_db_app/src/model/movie_detail.dart';
import 'package:movie_db_app/src/model/screen_shot.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(MovieDetailEventStated(movie.id)),
      child: WillPopScope(
        child: Scaffold(
          body: _buildDetailBody(context),
          backgroundColor: Color(0xFF151C26),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
        child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[


      BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),
          );
        } else if (state is MovieDetailLoaded) {
          MovieDetail movieDetail = state.detail;
          return Stack(
            children: <Widget>[
              ClipPath(
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original/${movieDetail.backdropPath}',
                    height: MediaQuery.of(context).size.height / 2.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/img_not_found.jpg'),
                        ),
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 120),
                    child: GestureDetector(
                      onTap: () async {
                        final youtubeUrl =
                            'https://www.youtube.com/embed/${movieDetail.trailerId}';
                        if (await canLaunch(youtubeUrl)) {
                          await launch(youtubeUrl);
                        }
                      },
                      child: Center(
                        child: Column(
                          children: <Widget>[
                                Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.red,
                                  size: 65,
                                ),
                              ],

                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text(
                    movieDetail.title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'muli',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                      ] ,
                  ),
                  SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                  Text(
                    "Rating : ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                      Text(
                        movie.voteAverage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        "/10",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 16,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Overview'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          //height:35,
                          child: Text(
                            movieDetail.overview,
                            style: TextStyle(fontFamily: 'muli',
                                color: Colors.grey,
                            fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 15,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Release date'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetail.releaseDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontFamily: 'muli',
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'run time'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetail.runtime+" min",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color:  Colors.grey,
                                        fontSize: 13,
                                        fontFamily: 'muli',
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'budget'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'muli',
                                      ),
                                ),

                                Text(
                                  movieDetail.budget + " USD",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontFamily: 'muli',
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 15),
                        Text(
                          'Casts'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'muli',
                              ),
                        ),
                        Container(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                              color: Colors.transparent,
                              width: 12,
                            ),
                            itemCount: movieDetail.castList.length,
                            itemBuilder: (context, index) {
                              Cast cast = movieDetail.castList[index];
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 3,
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                          imageBuilder:
                                              (context, imageBuilder) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                image: DecorationImage(
                                                  image: imageBuilder,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              Container(
                                            width: 80,
                                            height: 80,
                                            child: Center(
                                              child: Platform.isAndroid
                                                  ? CircularProgressIndicator()
                                                  : CupertinoActivityIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/img_not_found.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Text(
                                          cast.name.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontFamily: 'muli',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Text(
                                          cast.character.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 10,
                                            fontFamily: 'muli',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),


                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Snapshot'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'muli',
                          ),
                        ),
                        Container(
                          height: 155,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                            scrollDirection: Axis.horizontal,
                            itemCount: movieDetail.movieImage.backdrops.length,
                            itemBuilder: (context, index) {
                              Screenshot image =
                              movieDetail.movieImage.backdrops[index];
                              return Container(
                                child: Card(
                                  elevation: 3,
                                  borderOnForeground: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                        child: Platform.isAndroid
                                            ? CircularProgressIndicator()
                                            : CupertinoActivityIndicator(),
                                      ),
                                      imageUrl:
                                      'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),





                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    ),



          ],
        ),
    ),
    );
  }
    );
  }

}
