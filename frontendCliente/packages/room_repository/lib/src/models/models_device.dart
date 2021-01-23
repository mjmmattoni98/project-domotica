import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Device extends Equatable{

  final String estado;
  final String habitacionAsignada;
  final String id;
  final String tipo;
  final String nombre;

  const Device({
    @required this.estado,
    @required this.tipo,
    @required this.habitacionAsignada,
    @required this.id,
    @required this.nombre
  }) : assert(id != null),
  assert(estado != null),
  assert(tipo != null),
  assert(habitacionAsignada != null),
  assert(nombre != null);

  static const empty = Device(id: '', tipo: '', habitacionAsignada: "", estado: "", nombre: "");


  @override
  // TODO: implement props
  List<Object> get props => [id, tipo, habitacionAsignada, estado];


  Device.fromJson(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        estado  = parsedJSON['estado'],
        tipo = parsedJSON['tipo'],
        habitacionAsignada = parsedJSON['habitacion'],
        nombre = parsedJSON['nombre'];


}