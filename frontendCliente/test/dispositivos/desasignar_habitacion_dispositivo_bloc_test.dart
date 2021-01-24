import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_event.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_state.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class MockRoomRepository extends Mock implements RoomRepository {}
class MockDeviceRepository extends Mock implements DeviceRepository {}
void main(){
  MockRoomRepository mockRoomRepository;
  MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H06. Desasignar habitacion de un dispositivo', () {

    final dispositivo = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "cocina", id: "01", nombre: "dispositivo");
    final dispositivo_sin_habitacion = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "cocina", id: "02", nombre: "dispositivo");

    blocTest('E1. Valido - Habitacion desasignada del dispositivo',
        build: () {
          when(mockDeviceRepository.desasignacionDispositivos('01'))
              .thenAnswer((_) => Future.value(true));

          return DispositivoBloc(mockDeviceRepository);
        },
        act: (bloc) => bloc.add(DesasignarDispositivo(dispositivo)),
        expect: [
          DispositivosModificados(),
        ]
    );

    blocTest('E2. Inválido - Dispositivo sin habitacion asignada',
        build: () {
          when(mockDeviceRepository.desasignacionDispositivos('02'))
              .thenAnswer((_) => Future.value(false));

          return DispositivoBloc(mockDeviceRepository);
        },
        act: (bloc) => bloc.add(DesasignarDispositivo(dispositivo_sin_habitacion)),
        expect: [
          DispositivosError()
        ]
    );
  });
}