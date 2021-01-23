part of 'dispositivos_bloc.dart';

abstract class DispositivosEvent extends Equatable{
  const DispositivosEvent();
}

class ActualizarListaDispositivos extends DispositivosEvent{
  @override
  List<Object> get props => [];
}

class RemoveDispositivo extends DispositivosEvent{
  final String nombre;
  final bool confirmacion;

  const RemoveDispositivo(this.nombre, this.confirmacion);

  @override
  List<Object> get props => [nombre, confirmacion];
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

class CrearDispositivosDefault extends DispositivosEvent{
  @override
  List<Object> get props => [];
}

class CambiarEstadoHub extends DispositivosEvent{
  final Estado nuevoEstado;

  const CambiarEstadoHub(this.nuevoEstado);

  @override
  List<Object> get props => [nuevoEstado];
}