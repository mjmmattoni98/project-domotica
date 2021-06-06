import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/dispositivos_inactivos.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

void main() {
  RoomRepository roomRepository;
  DeviceRepository deviceRepository;
  AuthenticationRepository authenticationRepository;

  setUpAll(() { //Solamente se llama una vez al inicio de los test
    roomRepository = RoomRepository();
    deviceRepository = DeviceRepository();
    authenticationRepository = AuthenticationRepository();
    authenticationRepository.signUp(email: "al365287@uji.es", password: "qwerty123");
  });

  tearDown((){
    //Se llama siempre despues de cada test
  });

  group('H03/H04. Asignar habitacion a un dispositivo', () async {
    // List<Room> habitaciones;
    // roomRepository.getRoomList().listen(
    //         (List<Room> room) {
    //           habitaciones = room;
    //     },
    //     onDone:(){
    //       return habitaciones;
    //     });


    test('E1. Valido - Habitacion asignada al dispositivo', () async{
      //GIVEN
      roomRepository.createRoom('cocina_test');

      //WHEN
      deviceRepository.asignacionDispositivos(idDispositivo, idHabitacion)

    });
    blocTest('E1. Valido - Habitacion asignada al dispositivo',
        build: () {
          when(mockDeviceRepository.asignacionDispositivos(
                  dispositivoSinHabitacion.id, habitacion.id))
              .thenAnswer((_) => Future.value(true));

          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc
            .add(AsignarHabitacion(dispositivoSinHabitacion.id, habitacion.id)),
        expect: [InactivoAsignado()]);

    blocTest('E2. Inválido - No hay habitaciones a asignar',
        build: () {
          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) =>
            bloc.add(AsignarHabitacion(dispositivoSinHabitacion.id, "")),
        expect: [InactivoHabitacionSinNombreError()]);

    blocTest('E3. Inválido - Ya tiene una habitacion asignada',
        build: () {
          when(mockDeviceRepository.asignacionDispositivos(
                  dispositivoConHabitacion.id, habitacion.id))
              .thenAnswer((_) => Future.value(false));
          return InactivoBloc(mockDeviceRepository, mockRoomRepository);
        },
        act: (bloc) => bloc
            .add(AsignarHabitacion(dispositivoConHabitacion.id, habitacion.id)),
        expect: [InactivoHabitacionAsignada()]);
  });
}
