import 'package:equatable/equatable.dart';
import 'package:room_repository/room_repository.dart';


abstract class HabitacionState extends Equatable {
  const HabitacionState();
}

class HabitacionInitial extends HabitacionState{
  const HabitacionInitial();
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class ListaCargada extends HabitacionState{

  final List<Room> habitaciones;

  const ListaCargada(this.habitaciones);
  @override
  // TODO: implement props
  List<Object> get props => [habitaciones];

}

class ListaCargando extends HabitacionState{
  const ListaCargando();
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ListaError extends HabitacionState{
  final String mensaje;
  const ListaError(this.mensaje);
  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}