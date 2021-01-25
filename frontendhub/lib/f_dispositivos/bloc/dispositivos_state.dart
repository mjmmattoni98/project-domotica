part of 'dispositivos_bloc.dart';

abstract class DispositivosState extends Equatable {
  const DispositivosState();

  @override
  List<Object> get props => [];
}

class DispositivosInitial extends DispositivosState{
  const DispositivosInitial();
}

class SinDispositivos extends DispositivosState{}

class EsperandoConfirmacion extends DispositivosState{
  final Device device;
  final bool confimado;
  const EsperandoConfirmacion(this.confimado, this.device);

  @override
  List<Object> get props => [confimado];
}

class DispositivosModificados extends DispositivosState{
  final List<Device> devices;

  const DispositivosModificados(this.devices);

  @override
  List<Object> get props => [devices];
}

class DispositivosCargando extends DispositivosState{}

class DispositivoBorrado extends DispositivosState{
  final String mensaje;

  const DispositivoBorrado(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class DispositivoAnyadido extends DispositivosState{
  final String mensaje;

  const DispositivoAnyadido(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class DispositivoModificado extends DispositivosState{
  final String mensaje;

  const DispositivoModificado(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class DispositivosError extends DispositivosState{
  final String mensaje;

  const DispositivosError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class DispositivoNombreRepetido extends DispositivosState{}

class DispositivoInexistente extends DispositivosState{}