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

  group('H03/H04. Asignar habitacion a un dispositivo', () {
    final cocina = Room(id: '01', nombre: 'cocina');
    final dispositivo = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "cocina", id: "01", nombre: "dispositivo");
    final dispositivo_sin_habitacion = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "cocina", id: "02", nombre: "dispositivo");

    blocTest('E1. Valido - Habitacion desasignada del dispositivo',
        build: () {

          when(mockDeviceRepository.asignacionDispositivos('01','01'))
              .thenAnswer((_) => Future.value(true));

          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(AsignarHabitacion('01', '01')),
        expect: [
          InactivoAsignado()
        ]
    );

    blocTest('E2. Inválido - No hay habitaciones a asignar',
        build: () {
          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(AsignarHabitacion('01', "")),
        expect: [
          InactivoHabitacionSinNombreError()
        ]
    );
  });
}