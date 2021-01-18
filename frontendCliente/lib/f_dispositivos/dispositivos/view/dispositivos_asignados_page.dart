

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/view/dispositivos_asignados_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class DispositivosAsignadosPage extends StatelessWidget {

  final Room habitacionActual;

  const DispositivosAsignadosPage(this.habitacionActual);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        //user: user,
        title: "ESTADO",
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
          create: (_) => DispositivoBloc(DeviceRepository()),
          child: DispositivosAsignadosLogic(habitacionActual),
        ),
      ),
    );
  }

}
