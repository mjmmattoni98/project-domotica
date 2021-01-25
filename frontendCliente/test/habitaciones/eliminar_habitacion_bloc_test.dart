import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/listado_habitaciones.dart';
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
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H02. Eliminar habitacion', () {
    final cocina = Room(id: '01', nombre: 'cocina', activo: false);

    blocTest('E1. Valido - Habitación eliminada',
        build: () {
          when(mockRoomRepository.deleteRoom(cocina))
              .thenAnswer((_) async => sleep(Duration(milliseconds: 1)));

          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([cocina]));

          when(mockDeviceRepository.getDevicesInRoom(cocina))
              .thenAnswer((_) => Stream.value([]));

          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(EliminarHabitacion(cocina, true)),
        expect: [
          HabitacionCargando(),
          HabitacionEliminada("La habitación se ha borrado correctamente")
        ]
    );

    blocTest('E2. Invalido - No hay habitaciones',
        build: () {

          when(mockRoomRepository.deleteRoom(cocina))
              .thenAnswer((_) async => sleep(Duration(milliseconds: 1)));

          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([]));

          when(mockDeviceRepository.getDevicesInRoom(cocina))
              .thenAnswer((_) => Stream.value([]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(EliminarHabitacion(cocina, true)),
        expect: [
          HabitacionCargando(),
          HabitacionInexistente()
        ]
    );

    blocTest('E3. Válido/Invalido - Habitación con dispositivos asignados',
        build: () {
          final dispositivo = Device(id: "01", estado: Estado.INACTIVE, habitacionAsignada: "cocina", nombre: "dispositivo", tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO);

          when(mockRoomRepository.deleteRoom(cocina))
              .thenAnswer((_) async => sleep(Duration(milliseconds: 1)));

          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([cocina]));

          when(mockDeviceRepository.getDevicesInRoom(cocina))
              .thenAnswer((_) => Stream.value([dispositivo]));

          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(EliminarHabitacion(cocina, false)),
        expect: [
          HabitacionCargando(),
          HabitacionConDispositivos(cocina)
        ]
    );

  });
}