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
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H12. Listar habitaciones', () {
    final cocina = Room(id: '01', nombre: 'cocina');
    final comedor = Room(id: '02', nombre: 'comedor');

    blocTest('E1. Valido - Listado de habitaciones',
        build: () {

          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([cocina, comedor]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(ActualizarListarHabitaciones()),
        expect: [
          HabitacionCargando(),
          HabitacionesCargadas([cocina, comedor])
        ]
    );

    blocTest('E2. Válido/Invalido - No hay habitaciones',
        build: () {

          when(mockRoomRepository.getRoomListAct())
              .thenAnswer((_) => Future.value([]));
          return HabitacionBloc(mockRoomRepository, mockDeviceRepository);
        },
        act: (bloc) => bloc.add(ActualizarListarHabitaciones()),
        expect: [
          HabitacionCargando(),
          ListaError("NO HAY HABITACIONES")
        ]
    );
  });
}