import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/view/dispositivos_asignados_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:get_it/get_it.dart';
import 'package:authentication_repository/authentication_repository.dart';

class DispositivosAsignadosPage extends StatelessWidget {
  static Route route(Room habitacionActual) {
    return MaterialPageRoute<void>(builder: (_) => DispositivosAsignadosPage(habitacionActual));
  }

  final Room habitacionActual;

  const DispositivosAsignadosPage(this.habitacionActual);

  @override
  Widget build(BuildContext context) {
    final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: HomeAppBar(
        title: "ESTADO",
        user: user,
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
          child: BlocProvider(
            create: (_) => DispositivoBloc(GetIt.I<DeviceRepository>()),
            child: DispositivosAsignadosLogic(habitacionActual),
          ),
        ),
        // BlocProvider(
        //   create: (_) => DispositivoBloc(DeviceRepository()),
        //   child: DispositivosAsignadosLogic(habitacionActual),
        // ),
      ),
    );
  }

}
