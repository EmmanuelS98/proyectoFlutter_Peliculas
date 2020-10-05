import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/pelicula_models.dart';

class PeliculasProvider{
  
  String _apykey    = '7a36d3ebfe6999709f02ac827a9e6aed';
  String _url       = 'api.themoviedb.org';
  String _lenguage  = 'es-Es';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  
  
  final _popularesStreamControler = StreamController<List<Pelicula>>.broadcast();//aqui si crea el stream //es la tuberia

  Function(List<Pelicula>) get popularesSink => _popularesStreamControler.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamControler.stream;


  void disposeStream(){
    _popularesStreamControler?.close();
  }//cada que se cierra la pagina se tiene que cerrar el stream para no generar varios

  Future <List<Pelicula>> _procesarRespuesta(Uri url)async{
    
    final resp = await http.get( url ); 
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    
    return peliculas.items;

  }

  Future <List<Pelicula>>  getEnCines() async{
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key':_apykey,
      'lenguage':_lenguage
    });
    
    return await _procesarRespuesta(url);

  }

  Future <List<Pelicula>>  getPoulares() async{
    if(_cargando) return[];
    
    _cargando = true;
  
    _popularesPage ++;

    print('cargando mas img');

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key':_apykey,
      'lenguage':_lenguage,
      'page' : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    
    _populares.addAll(  resp  );//aqui se almacenan todas las peliculas
    popularesSink(  _populares  );

    _cargando = false;
    return resp;
    
  }

}