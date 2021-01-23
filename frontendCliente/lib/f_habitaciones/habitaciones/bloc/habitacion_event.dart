import 'package:equatable/equatable.dart';
import 'package:room_repository/room_repository.dart';

abstract class HabitacionEvent extends Equatable{
  const HabitacionEvent();
}

class ActualizarListarHabitaciones extends HabitacionEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class EliminarHabitacion extends HabitacionEvent{
  final Room habitacion;
  final bool confirmacion;

  const EliminarHabitacion(this.habitacion, this.confirmacion);

  @override
  List<Object> get props => [habitacion, confirmacion];

}

class AnadirHabitacion extends HabitacionEvent{
  final String nombre;

  AnadirHabitacion(this.nombre);

  @override
  // TODO: implement props
  List<Object> get props => [nombre];

}


class CambiarNombreHabitacion extends HabitacionEvent{
  final Room habitacion;
  final String nuevoNombre;

  const CambiarNombreHabitacion(this.habitacion, this.nuevoNombre);

  @override
  List<Object> get props => [habitacion];
}
