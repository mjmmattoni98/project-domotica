import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontendCliente/Habitacion.dart';
import 'package:frontendCliente/HabitacionesService.dart';
import 'package:test/test.dart';
import 'package:frontendCliente/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async' as async;

void main(){
  group('Listar habitaciones', (){
    HabitacionesService hs = new HabitacionesService();

    tearDown(() async {
      hs.limpiarEstado();
    });

    test('Listar habitaciones cuando hayan', () async {
      final Habitacion comedor = new Habitacion("comedor");
      final Habitacion cocina = new Habitacion("cocina");
      var creada = await hs.crearHabitacion(comedor);
      expect(creada, true);
      creada = await hs .crearHabitacion(cocina);
      expect(creada, true);
      final List<Habitacion> habitaciones = await hs.listarHabitaciones();
      expect(habitaciones.length, 2);
    });

    test('Listar habitaciones inexistentes', () async {
      final List<Habitacion> habitaciones = await hs.listarHabitaciones();
      expect(habitaciones.length, 0);
    });
  });
}
