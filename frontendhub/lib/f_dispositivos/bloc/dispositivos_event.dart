part of 'dispositivos_bloc.dart';

abstract class DispositivosEvent extends Equatable{
  const DispositivosEvent();
}

class ActualizarListarDispositivos extends DispositivosEvent{
  @override
  List<Object> get props => [];
}

class RemoveDispositivo extends DispositivosEvent{
  final Device device;

  const RemoveDispositivo(this.device);

  @override
  List<Object> get props => [device];
}

class CambiarNombreDispositivo extends DispositivosEvent{
  final Device device;
  final String nuevoNombre;

  const CambiarNombreDispositivo(this.device, this.nuevoNombre);

  @override
  List<Object> get props => [device, nuevoNombre];
}
