import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'package:room_repository/device_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontendCliente/app.dart';
import 'package:frontendCliente/simple_bloc_observer.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  final getIt = GetIt.instance;
  // Registramos un singleton del AuthenticationRepository
  getIt.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
  // Registramos un singleton del DeviceRepository
  getIt.registerSingleton<DeviceRepository>(DeviceRepository());
  // Registramos un singleton del RoomRepository
  getIt.registerSingleton<RoomRepository>(RoomRepository());
  Bloc.observer = SimpleBlocObserver();
  runApp(App(authenticationRepository: getIt<AuthenticationRepository>()));
}