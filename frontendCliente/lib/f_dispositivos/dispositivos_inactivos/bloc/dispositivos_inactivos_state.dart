import 'package:equatable/equatable.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

abstract class InactivoState extends Equatable{
  const InactivoState();

  @override
  List<Object> get props => [];
}


class InactivoInitial extends InactivoState{}

class InactivosActuales extends InactivoState{
  final List<Device> dispositivos;
  final List<Room> habitaciones;

  InactivosActuales(this.dispositivos, this.habitaciones);

  @override
  List<Object> get props => [dispositivos, habitaciones];
}

class InactivoAsignado extends InactivoState{}

class InactivoError extends InactivoState{}

class InactivoHabitacionAsignada extends InactivoState{}

class ListaInactivoError extends InactivoState{}

class InactivoHabitacionSinNombreError extends InactivoState{}

class InactivoHabitacionesError extends InactivoState{}
