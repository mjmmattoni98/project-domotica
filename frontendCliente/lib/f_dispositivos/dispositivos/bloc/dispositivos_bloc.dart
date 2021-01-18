import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_state.dart';
import 'package:room_repository/device_repository.dart';

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
      yield DispositivosActuales(event.dispositivos);
    }
  }


}