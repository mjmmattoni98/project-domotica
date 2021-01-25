import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/bloc/dispositivos_inactivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/view/dispositivos_inactivos_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:get_it/get_it.dart';
import 'package:authentication_repository/authentication_repository.dart';

class DispositivosInactivosPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DispositivosInactivosPage());
  }

  @override
  Widget build(BuildContext context) {
    // final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: HomeAppBar(
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
        child: RepositoryProvider.value(
          value: GetIt.I<DeviceRepository>(), // Singleton instance of the DeviceRepository
          child: RepositoryProvider.value(
            value: GetIt.I<RoomRepository>(), // Singleton instance of the RoomRepository
            child: BlocProvider(
              create: (_) => InactivoBloc(GetIt.I<DeviceRepository>(), GetIt.I<RoomRepository>()),
              child: DispositivosInactivosLogic(),
            ),
          ),
        ),
        // BlocProvider(
        //   create: (_) => InactivoBloc(DeviceRepository(), RoomRepository()),
        //   child: DispositivosInactivosLogic(),
        // ),
      ),
    );
  }
}