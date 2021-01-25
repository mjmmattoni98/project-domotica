import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/dispositivos.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

void main(){
  MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H07. Listar dispositivos habitacion', () {

    final cocina = Room(id: '01', nombre: 'cocina', activo: false);
    final dispositivo = Device(estado: Estado.INACTIVE, tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO, habitacionAsignada: "cocina", id: "01", nombre: "dispositivo");

    blocTest('E1. Valido - Lista dispositivos de una habitacion',
        build: () {

          when(mockDeviceRepository.getDevicesInRoom(cocina))
              .thenAnswer((_) => Stream.value([dispositivo]));

          return DispositivoBloc(mockDeviceRepository);
        },
        //Evento listar dispositivos
        act: (bloc) => bloc.add(DispositivosListados([dispositivo])),
        expect: [
          DispositivosActuales([dispositivo])
        ]
    );

    blocTest('E2. Inválido - No hay habitaciones',
        build: () {

          when(mockDeviceRepository.getDevicesInRoom(cocina))
              .thenAnswer((_) => Stream.value([]));

          return DispositivoBloc(mockDeviceRepository);
        },
        act: (bloc) => bloc.add(DispositivosListados([])),
        expect: [
          DispositivosListaError()
        ]
    );
  });
}