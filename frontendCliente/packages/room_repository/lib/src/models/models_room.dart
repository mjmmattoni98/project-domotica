import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/src/models/models_device.dart';

class Room extends Equatable{

  final String id;
  final String nombre;

  const Room({
    @required this.id,
    @required this.nombre,
  }) : assert(id != null),
    assert(nombre != null);

  static const empty = Room(id: '', nombre: '');

  @override
  // TODO: implement props
  List<Object> get props => [id, nombre];





  Room.fromJson(Map<String, dynamic> parsedJSON)
      : nombre = parsedJSON['nombre'],
        id = parsedJSON['id'];
}