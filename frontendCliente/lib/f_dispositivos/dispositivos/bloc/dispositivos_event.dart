part of 'dispositivos_bloc.dart';

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

class CambiarEstadoDispositivo extends DispositivoEvent{
  final Device device;
  final Estado nuevoEstado;

  const CambiarEstadoDispositivo(this.device, this.nuevoEstado);

  @override
  List<Object> get props => [device, nuevoEstado];
}

class DesasignarDispositivo extends DispositivoEvent{
  final Device dispositivo;

  DesasignarDispositivo(this.dispositivo);
  @override
  List<Object> get props => [dispositivo];
}
