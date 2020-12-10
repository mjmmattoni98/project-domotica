import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' as async;
import 'dart:convert';

import 'Habitacion.dart';

void main() {
  runApp(
    MaterialApp(home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map data;
  String petData;
  
  void getPeticiones() async {
    http.Response response = await http.get('https://spike-domotica.herokuapp.com/peticiones/getPeticion');
    /*if(response.statusCode == 200){
      return Peticion.fromJson(jsonDecode(response.body));
    }
    else{
    throw Exception('ha fallado el get');
    }*/
    data = json.decode(response.body);
    setState(() {
      petData = data['peticion']['name'];
    });
  }

  @override
  void initState(){
    super.initState();
    getPeticiones();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de peticiones'),
          backgroundColor: Colors.white12,
        ),
        body: Center(
            child: Text(petData)
        )
    );
  }
}