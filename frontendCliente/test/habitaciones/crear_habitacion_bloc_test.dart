import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class MockRoomRepository extends Mock implements RoomRepository {}
class MockDeviceRepository extends Mock implements DeviceRepository {}

void main() {
  MockRoomRepository mockRoomRepository;
  MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockRoomRepository = MockRoomRepository();
  });
  group('H01. Crear habitacion', () {
    blocTest('E1. Valido - Habitación creada',
        build: () {
          when(mockRoomRepository.createRoom('comedor'))
              .thenAnswer((_) async => sleep(Duration(milliseconds: 1)));
          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(AnadirHabitacion('comedor')),
        expect: [
          HabitacionCargando(),
          HabitacionAnadida("Habitacion añadida correctamente")
        ]
    );

    blocTest('E2. Invalido - Nombre de habitación repetido',
        build: () {
          final cocina = Room(id: '01', nombre: 'cocina');

          when(mockRoomRepository.createRoom('cocina'))
              .thenAnswer((_) async => sleep(Duration(milliseconds: 1)));
          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([cocina]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(AnadirHabitacion('cocina')),
        expect: [
          HabitacionCargando(),
          ErrorHabitacionExistente("Esta habitación ya existe")
        ]
    );
  });


}