import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontendHub/Habitacion.dart';
import 'package:http/http.dart' as http;
import 'dart:async' as async;
import 'dart:convert';

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
  Map<String, Habitacion> habitaciones = new HashMap();


  void crearHabitacion (String nombre) async {
    http.Response response = await http.get('https://spike-domotica.herokuapp.com/habitaciones/crearHabitacion');
    data = json.decode(response.body);
    petData = data['peticion']['nombre'];
    var habitacion = new Habitacion(nombre);
    response = await http.post('https://spike-domotica.herokuapp.com/habitaciones/crearHabitacion', body: jsonEncode(habitacion));
    print(response.statusCode);
    habitaciones[nombre] = habitacion;
  }

  void verEstadoHabitacion (String nombre) async {
    var habitacion = habitaciones[nombre];
    var dispositivos = habitacion.verEstado();
    http.Response response = await http.post('https://spike-domotica.herokuapp.com/habitaciones/estadoHabitacion', body: jsonEncode(dispositivos));
    print(response.statusCode);
  }

  void listarHabitaciones () async {
    http.Response response = await http.post('https://spike-domotica.herokuapp.com/habitaciones/listarHabitaciones', body: jsonEncode(habitaciones));
    print(response.statusCode);

  }

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