// Imports the Flutter Driver API.
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:room_repository/room_repository.dart';
import 'package:test/test.dart';

void main() {
 group('Prueba Integracion', () {

  //login screen
  final usernameField = find.byValueKey('username');
  final passwordField = find.byValueKey('password');
  final signInButton = find.byValueKey('signIn');
  final createAccountButton = find.byValueKey('createAccount');

  //home screen
  final signOutButton = find.byValueKey('signOut');
  final botonHabitaciones = find.byValueKey('habitaciones');
  final botonDispositivos = find.byValueKey('dispositivos');

  //Habitaciones screen
  final anadirHabitacionScroll = find.byValueKey('añadirHabitacionScroll');
  final anadirHabitacionField = find.byValueKey('añadirHabitacionField');
  final anadirHabitacionBoton = find.byValueKey('añadirHabitacionBoton');
  final listaHabitaciones = find.byValueKey('listaHabitaciones');

  FlutterDriver driver;

  Future<bool> isPresent(SerializableFinder byValueKey,
      {Duration timeout = const Duration(seconds: 1)}) async {
   try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
   } catch (exception) {
    return false;
   }
  }

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
   driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
   if (driver != null) {
    driver.close();
   }
  });

  test('create account', () async {
   if (await isPresent(signOutButton)) {
    await driver.tap(signOutButton);
   }

   await driver.tap(usernameField);
   await driver.enterText("los.acabaos.domotica@gmail.com");

   await driver.tap(passwordField);
   await driver.enterText("alecarmar");

   //Crear cuenta
   await driver.tap(createAccountButton);
  });

  test('login', () async {
   if (await isPresent(signOutButton)) {
    await driver.tap(signOutButton);
   }

   await driver.tap(usernameField);
   await driver.enterText("los.acabaos.domotica@gmail.com");

   await driver.tap(passwordField);
   await driver.enterText("alecarmar");

   //Login
   await driver.tap(signInButton);
  });

  test('Añadir habitacion', () async {

   await driver.tap(botonHabitaciones);
   await driver.tap(anadirHabitacionScroll);
   await driver.tap(anadirHabitacionField);
   await driver.enterText("cocina");
   await driver.tap(anadirHabitacionBoton);
   await driver.waitFor(find.byValueKey(listaHabitaciones),
        timeout: const Duration(seconds: 3));

   //expect(listaHabitaciones.length(), 1);
    
  });
 });
}