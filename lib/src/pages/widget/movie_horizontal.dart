import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_models.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;


  MovieHorizontal({ @required this.peliculas , @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {

  final _screenSize = MediaQuery.of(context).size;

  _pageController.addListener((){
    if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
      siguientePagina();
    }
  });
 
  return Container(
    height: _screenSize.height * 0.3,//aqui esta *2
    child: PageView.builder(
      pageSnapping: false,
      controller:_pageController,
      //children: _tarjetas(context),
      itemBuilder: (context, i) =>  _tarjeta(context, peliculas[i]),
      itemCount: peliculas.length,
    ),
  );   

  }

  Widget _tarjeta(BuildContext context , Pelicula pelicula){
    
      return Container(
        margin: EdgeInsets.only(right:15.0),
        child: Column(
          children:<Widget>[
             ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image:NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 1.0 ,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );


      // return GestureDetector(
      //   onTap: (()=>print(pelicula.title)) ,
      // );
  }

  List<Widget> _tarjetas(BuildContext context) {

    return peliculas.map((pelicula){

      return Container(
        margin: EdgeInsets.only(right:15.0),
        child: Column(
          children:<Widget>[
             ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image:NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0 ,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );

    }).toList();

  }
}