import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/bloc/dispositivos_inactivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/view/dispositivos_inactivos_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

class DispositivosInactivosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        //user: user,
        title: "INACTIVOS",
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
          create: (_) => InactivoBloc(DeviceRepository(), RoomRepository()),
          child: DispositivosInactivosLogic(),
        ),
      ),
    );
  }
}