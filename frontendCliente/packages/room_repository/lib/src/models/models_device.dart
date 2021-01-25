import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum TipoDispositivo{SENSOR_DE_APERTURA, DETECTOR_DE_MOVIMIENTO, ALARMA}

enum Estado{ACTIVE, INACTIVE, DISCONNECTED}

extension TipoEstado on TipoDispositivo{
  static const dispositivosMap = {
    TipoDispositivo.ALARMA: "alarma",
    TipoDispositivo.DETECTOR_DE_MOVIMIENTO: "movimiento",
    TipoDispositivo.SENSOR_DE_APERTURA: "apertura",
  };

  String get nombre => dispositivosMap[this]; // Devuelve un string del tipo del dispositivo

  // Devuelve un string dependiendo del estado en el que se encuentra y del tipo de dispositivo que lo ha llamado
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

/// {@template device}
/// Device model
///
/// {@endtemplate}
class Device extends Equatable{
  /// {@macro device}
  const Device({
    @required this.tipo,
    @required this.nombre,
    @required this.habitacionAsignada,
    this.id = "id desconocido",
    this.estado = Estado.INACTIVE,
  }) : assert(id != null),
        assert(habitacionAsignada != null),
        assert(nombre != null);

  /// The current device's state.
  final Estado estado;

  /// The current device's room (empty string if it is in no room).
  final String habitacionAsignada;

  /// Device's id.
  final String id;

  /// Device's type.
  final TipoDispositivo tipo;

  /// The current device's name.
  final String nombre;

  /// Devuelve un string del estado actual dependiendo del tipo del dispositivo
  String get estadoActual => tipo.getEstado(estado);

  /// Devuelve un string del tipo del dispositivo
  String get nombreTipo => tipo.nombre;

  static TipoDispositivo stringToTipo(String tipo){
    var tipoDispositivo;
    switch(tipo.toLowerCase()){
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
    switch(estado.toLowerCase()){
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

  static const empty = Device(tipo: null, habitacionAsignada: "", estado: null, nombre: "");

  @override
  List<Object> get props => [id, tipo, habitacionAsignada, estado, nombre];

  Device.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        estado  = stringToEstado(parsedJson['estado'].toLowerCase()),
        tipo = stringToTipo(parsedJson['tipo'].toLowerCase()),
        habitacionAsignada = parsedJson['habitacion'],
        nombre = parsedJson['nombre'];
}