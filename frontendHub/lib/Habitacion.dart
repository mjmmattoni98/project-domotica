import 'dart:collection';

class Habitacion{
  String nombre;
  var dispositivos;

  Habitacion(String nombre){
    this.nombre = nombre;
    this.dispositivos = new List();

  }

  Habitacion.fromJson(Map<String, dynamic> json)
    : nombre = json['nombre'],
      dispositivos = json['dispositivos'];

  Map<String, dynamic> toJson() =>
    {
      'nombre': nombre,
      'dispositivos': dispositivos,
    };

  List verEstado(){
    throw UnimplementedError();
  }

  String getNombre() {
    throw UnimplementedError();
  }

}
