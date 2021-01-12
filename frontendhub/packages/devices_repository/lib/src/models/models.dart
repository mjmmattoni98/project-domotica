import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum TipoDispositivo{SENSOR_DE_APERTURA, DETECTOR_DE_MOVIMIENTO, ALARMA}

enum Estado{ACTIVE, INACTIVE, DISCONNECTED}

extension on TipoDispositivo{
  static const dispositivosMap = {
    TipoDispositivo.ALARMA: "alarma",
    TipoDispositivo.DETECTOR_DE_MOVIMIENTO: "movimiento",
    TipoDispositivo.SENSOR_DE_APERTURA: "apertura",
  };

  String get nombre => dispositivosMap[this];

  String getEstado(Estado estado){
    String nombreEstado = "";
    switch(estado){
      case Estado.ACTIVE:
        switch(this) {
          case TipoDispositivo.SENSOR_DE_APERTURA:
            nombreEstado = "open";
            break;
          case TipoDispositivo.DETECTOR_DE_MOVIMIENTO:
            nombreEstado = "motion_detected";
            break;
          case TipoDispositivo.ALARMA:
            nombreEstado = "on";
            break;
        }
        break;
      case Estado.INACTIVE:
        switch(this) {
          case TipoDispositivo.SENSOR_DE_APERTURA:
            nombreEstado = "close";
            break;
          case TipoDispositivo.DETECTOR_DE_MOVIMIENTO:
            nombreEstado = "no_motion";
            break;
          case TipoDispositivo.ALARMA:
            nombreEstado = "off";
            break;
        }
        break;
      case Estado.DISCONNECTED:
        nombreEstado = "disconnected";
        break;
      default:
        break;
    }
    return nombreEstado;
  }
}

/// {@template user}
/// Device model
///
/// {@endtemplate}
class Device extends Equatable {
  /// {@macro device}
  Device({
    @required this.email,
    @required this.idDevice,
    @required this.uid,
    @required this.name,
    @required this.tipo,
    this.estado = Estado.INACTIVE
  })  : assert(email != null),
        assert(idDevice != null),
        assert(uid != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String uid;

  /// The current device's id.
  final String idDevice;

  /// Device's type.
  final TipoDispositivo tipo;

  /// The current device's name.
  String name;

  /// The current device's state.
  Estado estado;

  String get estadoActual => tipo.getEstado(estado);

  String get nombreTipo => tipo.nombre;

  Device withState(Estado estado){
    this.estado = estado;
    return this;
  }

  @override
  List<Object> get props => [email, uid, idDevice, name, estado, tipo];
}