import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

part 'dispositivos_event.dart';
part 'dispositivos_state.dart';

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
    else if(event is DispositivosListados){
      if(event.dispositivos.length == 0)
        yield DispositivosListaError();
      else
        yield DispositivosActuales(event.dispositivos);
    }
    else if (event is CambiarEstadoDispositivo){
      String nuevoEstado = event.device.tipo.getEstado(event.nuevoEstado);
      await _deviceRepository.updateDeviceState(event.device.id, nuevoEstado);
      yield DispositivosModificados();
    }
    else if(event is DesasignarDispositivo){
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