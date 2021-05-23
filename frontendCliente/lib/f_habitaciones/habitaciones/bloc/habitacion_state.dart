part of "habitacion_bloc.dart";

abstract class HabitacionState extends Equatable {
  const HabitacionState();

  @override
  List<Object> get props => [];
}


class HabitacionesInitial extends HabitacionState{}

class EsperandoConfirmacion extends HabitacionState{
  final Room habitacion;
  final bool confimado;

  const EsperandoConfirmacion(this.confimado, this.habitacion);

  @override
  List<Object> get props => [confimado];
}

class HabitacionesCargadas extends HabitacionState{
  final List<Room> habitaciones;

  const HabitacionesCargadas(this.habitaciones);

  @override
  List<Object> get props => [habitaciones];
}

class HabitacionCargando extends HabitacionState{}

class HabitacionEliminada extends HabitacionState{
  final String mensaje;

  const HabitacionEliminada(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}


class HabitacionAnadida extends HabitacionState{
  final String mensaje;

  const HabitacionAnadida(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class HabitacionModificada extends HabitacionState{
  final String mensaje;

  const HabitacionModificada(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class ListaError extends HabitacionState{
  final String mensaje;

  const ListaError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class HabitacionRepetida extends HabitacionState{}

class HabitacionSinNombre extends HabitacionState {}

class HabitacionesActuales extends HabitacionState{
  final List<Room> habitaciones;

  HabitacionesActuales(this.habitaciones);

  @override
  List<Object> get props => [habitaciones];
}

class HabitacionInexistente extends HabitacionState {}

class ErrorHabitacionExistente extends HabitacionState{
  final String mensaje;

  const ErrorHabitacionExistente(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class HabitacionConDispositivos extends HabitacionState{
  final Room habitacion;

  HabitacionConDispositivos(this.habitacion);

  @override
  List<Object> get props => [habitacion];
}