import 'package:equatable/equatable.dart';
import 'package:room_repository/device_repository.dart';

abstract class DispositivoState extends Equatable{
  const DispositivoState();

  @override
  List<Object> get props => [];
}


class DispositivosInitial extends DispositivoState{}

class DispositivosActuales extends DispositivoState{
  final List<Device> dispositivos;

  DispositivosActuales(this.dispositivos);

  @override
  List<Object> get props => [dispositivos];
}

class DispositivosModificados extends DispositivoState{}

class DispositivosError extends DispositivoState{}

class DispositivosListaError extends DispositivoState{}

