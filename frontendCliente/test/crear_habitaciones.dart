import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontendCliente/Habitacion.dart';
import 'package:frontendCliente/HabitacionesService.dart';
import 'package:test/test.dart';
import 'package:frontendCliente/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async' as async;

void main(){
  group('Creacion de habitaciones', (){
    HabitacionesService hs = new HabitacionesService();

    tearDown(() async {
      hs.limpiarEstado();
    });

    test('Crear habitacion que no existe', () async {
      const String nombre = "comedor";
      final Habitacion comedor = new Habitacion(nombre);
      final bool creada = await hs.crearHabitacion(comedor);
      expect(creada, true);
    });

    test('Crear habitacion ya existente', () async {
      const String nombre = "comedor";
      final Habitacion comedor = new Habitacion(nombre);
      final Habitacion h2 = new Habitacion("comedor");
      final bool creada = await hs.crearHabitacion(comedor);
      expect(creada, true);
      final bool creada2 = await hs.crearHabitacion(comedor);
      expect(creada2, false);
    });
  });
}
