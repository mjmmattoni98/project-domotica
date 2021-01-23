


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendCliente/Widgets/floating_button.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';

import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/view/listado_habitaciones_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class ListaHabitacionesPage extends StatefulWidget{
  static Route route() {
    return MaterialPageRoute<void>(builder: (context) => ListaHabitacionesPage().build(context));
  }
  @override
  Widget build(BuildContext context) {
    return _ListaHabitacionesPageState().build(context);
  }

  @override
  State<StatefulWidget> createState() {
    return _ListaHabitacionesPageState();
  }

}
class _ListaHabitacionesPageState extends State<ListaHabitacionesPage>{
  bool showBottomMenu = false;
  TextEditingController controladorNombre = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HomeAppBar(
        //user: user,
        title: "HABITACIONES",
        gradientBegin: Colors.black87,
        gradientEnd: Colors.black87,
        gradientMid: Colors.black54,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white38,
                  Colors.black54
                ]
            )
        ),
        child: BlocProvider(
          create: (_) => HabitacionBloc(RoomRepository(), DeviceRepository()),
          child: ListaHabitacionesLogic(),
        ),
      ),
    );
  }



}



