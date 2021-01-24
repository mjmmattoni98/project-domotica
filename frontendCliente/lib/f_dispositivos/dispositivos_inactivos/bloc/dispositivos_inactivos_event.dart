import 'package:equatable/equatable.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

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

class InactivosStarted extends InactivoEvent{

}


class AsignarHabitacion extends InactivoEvent{
  final String idDispositivo;
  final String idHabitacion;

  AsignarHabitacion(this.idDispositivo, this.idHabitacion);
  @override
  List<Object> get props => [idDispositivo, idHabitacion];
}