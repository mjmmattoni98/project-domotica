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
    final habitacion = Room(id: '01', nombre: 'cocina');
    final dispositivo_sin_habitacion = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "", id: "01", nombre: "dispositivo");
    final dispositivo_con_habitacion = Device(estado: "apagado", tipo: "movimiento", habitacionAsignada: "cocina", id: "01", nombre: "dispositivo");

    blocTest('E1. Valido - Habitacion asignada al dispositivo',
        build: () {

          when(mockDeviceRepository.asignacionDispositivos(dispositivo_sin_habitacion.id,habitacion.id))
              .thenAnswer((_) => Future.value(true));

          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(AsignarHabitacion(dispositivo_sin_habitacion.id, habitacion.id)),
        expect: [
          InactivoAsignado()
        ]
    );

    blocTest('E2. Inválido - No hay habitaciones a asignar',
        build: () {
          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(AsignarHabitacion(dispositivo_sin_habitacion.id, "")),
        expect: [
          InactivoHabitacionSinNombreError()
        ]
    );

    blocTest('E3. Inválido - Ya tiene una habitacion asignada',
        build: () {
          when(mockDeviceRepository.asignacionDispositivos(dispositivo_con_habitacion.id, habitacion.id))
              .thenAnswer((_) => Future.value(false));
          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc.add(AsignarHabitacion(dispositivo_con_habitacion.id, habitacion.id)),
        expect: [
          InactivoHabitacionAsignada()
        ]
    );
  });
}