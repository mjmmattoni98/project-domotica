import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontendCliente/Habitacion.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/HabitacionesService.dart';
import 'package:test/test.dart';
import 'package:frontendCliente/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async' as async;

void main(){
  group('Cambiar nombre de habitación', (){
    HabitacionesService hs = new HabitacionesService();

    tearDown(() async {
      hs.limpiarEstado();
    });

    test('Cambiar nombre de habitacion por uno no existente', () async {
      final Habitacion comedor = new Habitacion("comedor");
      final Habitacion cocina = new Habitacion("cocina");
      var creada = await hs.crearHabitacion(comedor);
      expect(creada, true);
      creada = await hs .crearHabitacion(cocina);
      expect(creada, true);
      final bool cambiadoNombre = await hs.cambiarNombreHabitacion(cocina, "dormitorio");
      expect(cambiadoNombre, true);
    });

    test('Cambiar nombre de habitacion por uno no existente', () async {
      final Habitacion comedor = new Habitacion("comedor");
      final Habitacion cocina = new Habitacion("cocina");
      var creada = await hs.crearHabitacion(comedor);
      expect(creada, true);
      creada = await hs .crearHabitacion(cocina);
      expect(creada, true);
      final bool cambiadoNombre = await hs.cambiarNombreHabitacion(cocina, "comedor");
      expect(cambiadoNombre, false);
    });
  });
}
