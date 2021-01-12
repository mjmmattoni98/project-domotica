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

class RemoveHabitacion extends HabitacionEvent{
  final Room habitacion;

  const RemoveHabitacion(this.habitacion);

  @override
  List<Object> get props => [habitacion];

}

class CambiarNombreHabitacion extends HabitacionEvent{
  final Room habitacion;
  final String nuevoNombre;

  const CambiarNombreHabitacion(this.habitacion, this.nuevoNombre);

  @override
  List<Object> get props => [habitacion];
}
