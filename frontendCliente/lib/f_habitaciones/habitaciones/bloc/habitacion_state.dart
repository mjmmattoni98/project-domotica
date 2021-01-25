import 'package:equatable/equatable.dart';
import 'package:frontendCliente/Habitacion.dart';
import 'package:room_repository/room_repository.dart';

abstract class HabitacionState extends Equatable {
  const HabitacionState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class HabitacionesInitial extends HabitacionState{
  const HabitacionesInitial();
  //const HabitacionInitial(this.habitaciones);
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class EsperandoConfirmacion extends HabitacionState{
  final Room habitacion;
  final bool confimado;
  const EsperandoConfirmacion(this.confimado, this.habitacion);

  @override
  // TODO: implement props
  List<Object> get props => [confimado];
}

class HabitacionesCargadas extends HabitacionState{
  final List<Room> habitaciones;
  const HabitacionesCargadas(this.habitaciones);
  @override
  // TODO: implement props
  List<Object> get props => [habitaciones];
}

class HabitacionCargando extends HabitacionState{


}


class HabitacionEliminada extends HabitacionState{
  final String mensaje;

  const HabitacionEliminada(this.mensaje);

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

class ListaError extends HabitacionState{
  final String mensaje;
  const ListaError(this.mensaje);
  @override
  // TODO: implement props
  List<Object> get props => [mensaje];

}

class HabitacionRepetida extends HabitacionState{

}

class HabitacionSinNombre extends HabitacionState {

}

class HabitacionInexistente extends HabitacionState {

}

class ErrorHabitacionExistente extends HabitacionState{
  final String mensaje;
  const ErrorHabitacionExistente(this.mensaje);
  @override
  // TODO: implement props
  List<Object> get props => [mensaje];
}

class HabitacionConDispositivos extends HabitacionState{
  final Room habitacion;
  HabitacionConDispositivos(this.habitacion);
  @override
  // TODO: implement props
  List<Object> get props => [habitacion];
}