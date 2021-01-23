import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum TipoDispositivo{SENSOR_DE_APERTURA, DETECTOR_DE_MOVIMIENTO, ALARMA}

enum Estado{ACTIVE, INACTIVE, DISCONNECTED}

extension TipoEstado on TipoDispositivo{
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
  const Device({
    @required this.name,
    @required this.tipo,
    this.estado = Estado.INACTIVE,
    this.id = "id desconocido",
  })  : assert(name != null);

  /// Device's type.
  final TipoDispositivo tipo;

  /// Device's type.
  final String id;

  /// The current device's name.
  final String name;

  /// The current device's state.
  final Estado estado;

  String get estadoActual => tipo.getEstado(estado);

  String get nombreTipo => tipo.nombre;

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

  static const empty = Device(name: "", tipo: null, estado: null);

  Device.fromJson(Map<String, dynamic> parsedJson)
    : name = parsedJson['nombre'],
      id = parsedJson['id'],
      tipo = stringToTipo(parsedJson['tipo'].toLowerCase()),
      estado = stringToEstado(parsedJson['estado'].toLowerCase());

  @override
  List<Object> get props => [name, estado, tipo, id];
}