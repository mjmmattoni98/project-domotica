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
    @required this.idDevice,
    @required this.uid,
    @required this.name,
    @required this.tipo,
    this.estado = Estado.INACTIVE
  })  : assert(idDevice != null),
        assert(uid != null);

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

  static TipoDispositivo stringToTipo(String tipo){
    var tipoDispositivo;
    switch(tipo){
      case "alarma":
        tipoDispositivo = TipoDispositivo.ALARMA;
        break;
      case "movimiento":
        tipoDispositivo = TipoDispositivo.DETECTOR_DE_MOVIMIENTO;
        break;
      case "apertura":
        tipoDispositivo = TipoDispositivo.SENSOR_DE_APERTURA;
        break;
      default:
        tipoDispositivo = null;
        break;
    }
    return tipoDispositivo;
  }

  static Estado stringToEstado(String estado){
    var tipoEstado;
    switch(estado){
      case "open":
      case "motion_detected":
      case "on":
        tipoEstado = Estado.ACTIVE;
        break;
      case "close":
      case "no_motion":
      case "off":
        tipoEstado = Estado.INACTIVE;
        break;
      case "disconnected":
        tipoEstado = Estado.DISCONNECTED;
        break;
      default:
        tipoEstado = null;
        break;
    }
    return tipoEstado;
  }

  Device.fromJson(Map<String, dynamic> parsedJson, String id)
    : uid = parsedJson['uid'],
      idDevice = id,
      name = parsedJson['name'],
      tipo = stringToTipo(parsedJson['tipo'].toLowerCase()),
      estado = stringToEstado(parsedJson['estado'].toLowerCase());

  @override
  List<Object> get props => [uid, idDevice, name, estado, tipo];
}