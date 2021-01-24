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

void main(){
  MockRoomRepository mockRoomRepository;
  MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H05. Cambiar nombre habitacion', () {

    final cocina = Room(id: '01', nombre: 'cocina');
    final comedor = Room(id: '02', nombre: 'comedor');

    blocTest('E1. Valido - Nombre habitación cambiado',
        build: () {
          when(mockRoomRepository.changeName(cocina, 'cocina'))
              .thenAnswer((_) async =>  sleep(Duration(milliseconds: 1)));
          when(mockRoomRepository.getRoomListAct()).thenAnswer((_) => Future.value([cocina]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(CambiarNombreHabitacion(cocina, 'salon')),
        expect: [
          HabitacionCargando(),
          HabitacionModificada('Habitacion modificada con éxito')
        ]
    );

    blocTest('E2. Invalido - Habitacion repetida',
        build: () {
          when(mockRoomRepository.changeName(comedor, 'cocina'))
              .thenAnswer((_) async =>  sleep(Duration(milliseconds: 1)));
          when(mockRoomRepository.getRoomListAct()).thenAnswer((_) => Future.value([cocina]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(CambiarNombreHabitacion(comedor, 'cocina')),
        expect: [
          HabitacionCargando(),
          HabitacionRepetida()
        ]
    );
});



}