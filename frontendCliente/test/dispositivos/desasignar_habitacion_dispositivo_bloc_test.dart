import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/dispositivos.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

void main(){
  MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockDeviceRepository = MockDeviceRepository();
  });

  group('H06. Desasignar habitacion de un dispositivo', () {

    final dispositivo = Device(estado: Estado.INACTIVE, tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO, habitacionAsignada: "cocina", id: "01", nombre: "dispositivo");
    final dispositivoSinHabitacion = Device(estado: Estado.INACTIVE, tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO, habitacionAsignada: "cocina", id: "02", nombre: "dispositivo");

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
        act: (bloc) => bloc.add(DesasignarDispositivo(dispositivoSinHabitacion)),
        expect: [
          DispositivosError()
        ]
    );
  });
}