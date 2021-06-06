part of 'dispositivos_bloc.dart';

abstract class DispositivosEvent extends Equatable{
  const DispositivosEvent();

  @override
  List<Object> get props => [];
}

class DispositivosStarted extends DispositivosEvent{}

class ActualizarListaDispositivos extends DispositivosEvent{
  final List<Device> dispositivos;

  ActualizarListaDispositivos(this.dispositivos);
  @override
  List<Object> get props => [dispositivos];
}

class RemoveDispositivo extends DispositivosEvent{
  final String idDispositivo;

  const RemoveDispositivo(this.idDispositivo);

  @override
  List<Object> get props => [idDispositivo];
}

class AddDispositivo extends DispositivosEvent{
  final String nombre;
  final TipoDispositivo tipo;

  AddDispositivo(this.nombre, this.tipo);

  @override
  List<Object> get props => [nombre, tipo];
}

class CambiarNombreDispositivo extends DispositivosEvent{
  final Device device;
  final String nuevoNombre;

  const CambiarNombreDispositivo(this.device, this.nuevoNombre);

  @override
  List<Object> get props => [device, nuevoNombre];
}

class CambiarEstadoDispositivo extends DispositivosEvent{
  final Device device;
  final Estado nuevoEstado;

  const CambiarEstadoDispositivo(this.device, this.nuevoEstado);

  @override
  List<Object> get props => [device, nuevoEstado];
}

class CrearDispositivosDefault extends DispositivosEvent{}

class CambiarEstadoHub extends DispositivosEvent{
  final Estado nuevoEstado;

  const CambiarEstadoHub(this.nuevoEstado);

  @override
  List<Object> get props => [nuevoEstado];
}
