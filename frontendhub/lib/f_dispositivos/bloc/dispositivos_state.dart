part of 'dispositivos_bloc.dart';

abstract class DispositivosState extends Equatable {
  const DispositivosState();
}

class DispositivosInitial extends DispositivosState{
  const DispositivosInitial();
  @override
  List<Object> get props => [];
}

class DispositivosCargados extends DispositivosState{
  final List<Device> devices;
  const DispositivosCargados(this.devices);
  @override
  List<Object> get props => [devices];
}

class DispositivosCargando extends DispositivosState{
  @override
  List<Object> get props => [];
}

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