part of "dispositivos_inactivos_bloc.dart";

abstract class InactivoEvent extends Equatable{
  const InactivoEvent();

  @override
  List<Object> get props => [];
}


class InactivosListados extends InactivoEvent{
  final List<Device> dispositivos;

  InactivosListados(this.dispositivos);
  @override
  List<Object> get props => [dispositivos];
}

class InactivosStarted extends InactivoEvent{}

class AsignarHabitacion extends InactivoEvent{
  final String idDispositivo;
  final String idHabitacion;

  AsignarHabitacion(this.idDispositivo, this.idHabitacion);
  @override
  List<Object> get props => [idDispositivo, idHabitacion];
}