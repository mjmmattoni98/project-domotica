import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_state.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

import 'dispositivos_event.dart';

class DispositivoBloc extends Bloc<DispositivoEvent, DispositivoState>{
  final DeviceRepository _deviceRepository;
  StreamSubscription _subscription;

  DispositivoBloc(this._deviceRepository) : super(DispositivosInitial());

  @override
  Stream<DispositivoState> mapEventToState(event) async*{
    if(event is DispositivosStarted) {
      _subscription?.cancel();
      _subscription = _deviceRepository.getDevicesInRoom(event.habitacion).listen((event) {add(DispositivosListados(event));});
    }
    if(event is DispositivosListados){
      if(event.dispositivos.length == 0)
        yield DispositivosListaError();
      yield DispositivosActuales(event.dispositivos);
    }

    if(event is DesasignarDispositivo){
      yield await desasignarDispositivo(event.dispositivo);
    }
  }

  Future<DispositivoState> desasignarDispositivo(Device dispositivo) async{
    bool exito = await _deviceRepository.desasignacionDispositivos(dispositivo.id);
    if(exito)
      return  DispositivosModificados();
    return DispositivosError();
  }
}