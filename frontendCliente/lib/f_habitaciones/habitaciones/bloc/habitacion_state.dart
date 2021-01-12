import 'package:equatable/equatable.dart';
import 'package:frontendCliente/Habitacion.dart';
import 'package:room_repository/room_repository.dart';

abstract class HabitacionState extends Equatable {
  const HabitacionState();
}


class HabitacionesInitial extends HabitacionState{
  const HabitacionesInitial();
  //const HabitacionInitial(this.habitaciones);
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class HabitacionesCargadas extends HabitacionState{
  final List<Room> habitaciones;
  const HabitacionesCargadas(this.habitaciones);
  @override
  // TODO: implement props
  List<Object> get props => [habitaciones];
}

class HabitacionCargando extends HabitacionState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}


class HabitacionBorrada extends HabitacionState{
  final String mensaje;

  const HabitacionBorrada(this.mensaje);

  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}


class HabitacionAnadida extends HabitacionState{
  final String mensaje;

  const HabitacionAnadida(this.mensaje);
  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}

class HabitacionModificada extends HabitacionState{
  final String mensaje;
  const HabitacionModificada(this.mensaje);

  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}

/*
class ListaCargando extends HabitacionState{
  const ListaCargando();
  @override
  // TODO: implement props
  List<Object> get props => [];

}*/

class ListaError extends HabitacionState{
  final String mensaje;
  const ListaError(this.mensaje);
  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}