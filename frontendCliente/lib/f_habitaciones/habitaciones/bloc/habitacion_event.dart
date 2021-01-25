part of "habitacion_bloc.dart";

abstract class HabitacionEvent extends Equatable{
  const HabitacionEvent();

  @override
  List<Object> get props => [];
}

class ActualizarListarHabitaciones extends HabitacionEvent{}

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
  List<Object> get props => [nombre];

}

class CambiarNombreHabitacion extends HabitacionEvent{
  final Room habitacion;
  final String nuevoNombre;

  const CambiarNombreHabitacion(this.habitacion, this.nuevoNombre);

  @override
  List<Object> get props => [habitacion];
}
