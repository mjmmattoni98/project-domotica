import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'dispositivos_inactivos_event.dart';
import 'dispositivos_inactivos_state.dart';

class InactivoBloc extends Bloc<InactivoEvent, InactivoState> {
  final DeviceRepository _deviceRepository;
  final RoomRepository _roomRepository;
  StreamSubscription _subscription;

  InactivoBloc(this._deviceRepository, this._roomRepository)
      : super(InactivoInitial());

  @override
  Stream<InactivoState> mapEventToState(InactivoEvent event) async* {
    if (event is InactivosStarted) {
      _subscription?.cancel();
      _subscription = _deviceRepository.getDevicesInactive().listen((inactiveDevices) {
        add(InactivosListados(inactiveDevices));
      });
    }
    if (event is InactivosListados) {
      if(event.dispositivos.length == 0)
        yield InactivoError();
      List<Room> habitaciones = await _roomRepository.getRoomListAct();
      yield InactivosActuales(event.dispositivos, habitaciones);
    }
    if(event is AsignarHabitacion){
      bool exito = await _deviceRepository.asignacionDispositivos(event.dispositivo.id, event.habitacion.id);
      if(exito)
        yield InactivoAsignado();
      else
        yield InactivoError();
    }
  }
}