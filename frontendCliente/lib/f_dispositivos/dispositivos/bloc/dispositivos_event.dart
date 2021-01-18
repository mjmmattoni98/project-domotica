import 'package:equatable/equatable.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

abstract class DispositivoEvent extends Equatable{
  const DispositivoEvent();

  @override
  List<Object> get props => [];
}

class DispositivosStarted extends DispositivoEvent{
  final Room habitacion;

  DispositivosStarted(this.habitacion);

  @override
  List<Object> get props => [habitacion];

}

class DispositivosListados extends DispositivoEvent{
  final List<Device> dispositivos;

  DispositivosListados(this.dispositivos);
  @override
  List<Object> get props => [dispositivos];

}

class DispositivosModificados extends DispositivoEvent{}