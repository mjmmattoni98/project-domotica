import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/listado_habitaciones.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/view/listado_habitaciones_logic.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

class ListaHabitacionesPage extends StatefulWidget{
  static Route route() {
    return MaterialPageRoute<void>(builder: (context) => ListaHabitacionesPage().build(context));
  }

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
    // final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: HomeAppBar(
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
        child: RepositoryProvider.value(
          value: GetIt.I<DeviceRepository>(), // Singleton instance of the DeviceRepository
          child: RepositoryProvider.value(
            value: GetIt.I<RoomRepository>(), // Singleton instance of the RoomRepository
            child: BlocProvider(
              create: (_) => HabitacionBloc(GetIt.I<RoomRepository>(), GetIt.I<DeviceRepository>()),
              child: ListaHabitacionesLogic(),
            ),
          ),
        ),
      ),
    );
  }
}



