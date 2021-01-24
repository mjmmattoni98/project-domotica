import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_event.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_state.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/bloc/dispositivos_inactivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/bloc/dispositivos_inactivos_event.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/bloc/dispositivos_inactivos_state.dart';
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

  group('H09. Listar dispositivos sin habitacion asignada', () {

    final cocina = Room(id: '01', nombre: 'cocina');
    final dispositivo = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "", id: "01", nombre: "movimiento1");
    final dispositivo2 = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "", id: "02", nombre: "movimiento2");

    blocTest('E1. Valido - Lista dispositivos sin habitacion',
        build: () {
          when(mockRoomRepository.getRoomListAct())
          .thenAnswer((realInvocation) => Future.value([cocina]));

          when(mockDeviceRepository.getDevicesInactive())
              .thenAnswer((_) => Stream.value([dispositivo, dispositivo2]));

          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        //Evento listar dispositivos
        act: (bloc) => bloc.add(InactivosListados([dispositivo, dispositivo2])),
        expect: [
          InactivosActuales([dispositivo, dispositivo2], [cocina])
        ]
    );

    blocTest('E2. Inválido - No hay dispositivos inactivos',
        build: () {
          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((realInvocation) => Future.value([cocina]));

          when(mockDeviceRepository.getDevicesInactive())
              .thenAnswer((_) => Stream.value([]));

          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(InactivosListados([])),
        expect: [
          InactivoError(),
          InactivosActuales([], [cocina])
        ]
    );
  });
}