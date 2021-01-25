import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// {@template room}
/// room model
///
/// {@endtemplate}
class Room extends Equatable{
  /// {@macro room}
  const Room({
    @required this.id,
    @required this.nombre,
    @required this.activo,
  }) : assert(id != null),
        assert(nombre != null),
        assert(activo != null);

  /// Room's id.
  final String id;

  /// The current room's name.
  final String nombre;

  /// If the room has an active device
  final bool activo;

  static const empty = Room(id: '', nombre: '', activo: false);

  @override
  List<Object> get props => [id, nombre];

  Room.fromJson(Map<String, dynamic> parsedJSON)
      : nombre = parsedJSON['nombre'],
        activo = parsedJSON['activo'],
        id = parsedJSON['id'];
}