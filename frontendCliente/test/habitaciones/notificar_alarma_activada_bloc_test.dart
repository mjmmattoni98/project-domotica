import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class MockRoomRepository extends Mock implements RoomRepository {}
class MockDeviceRepository extends Mock implements DeviceRepository {}

void main() {

  group('H10. Notificar alarma activada', () {
    test('E01. Válido - Notifica dispositivo con habitacion activo', () {
      final dispositivo_activo_con_habitacion_asignada = Device(estado: Estado.ACTIVE, tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO, habitacionAsignada: "habitacion_activa", id: "dev01", nombre: "dispositivo1");
      final habitacion_activa = Room(id: 'habitacion_activa', nombre: 'cocina', activo: true);

      //El dispositivo está activo y se le notifica al usuario
      expect(dispositivo_activo_con_habitacion_asignada.estado, Estado.ACTIVE);
      expect(dispositivo_activo_con_habitacion_asignada.habitacionAsignada, "habitacion_activa");

      expect(habitacion_activa.activo, true);

    });

    test('E02. Inválido - No notifica dispositivo sin habitacion activo', () {
      final dispositivo_activo_sin_habitacion_asignada = Device(estado: Estado.ACTIVE, tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO, habitacionAsignada: "", id: "dev01", nombre: "dispositivo1");
      final habitacion_inactiva = Room(id: 'habitacion_inactiva', nombre: 'cocina', activo: false);

      //El dispositivo está activo pero no se notifica al usuario
      expect(dispositivo_activo_sin_habitacion_asignada.estado, Estado.ACTIVE);
      expect(dispositivo_activo_sin_habitacion_asignada.habitacionAsignada, "");

      expect(habitacion_inactiva.activo, false);
    });
  });
}