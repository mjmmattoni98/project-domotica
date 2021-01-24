import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/view/dispositivos_inactivos_logic.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/view/dispositivos_inactivos_page.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/view/listado_habitaciones_page.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:frontendCliente/home/home.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:room_repository/room_repository.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return HomePageView();
     /*RepositoryProvider.value(
      value: roomRepository,
      child: HomePageView().build(context),*/
      // child: BlocProvider(
      //   create: (_) => AuthenticationBloc(
      //     authenticationRepository: authenticationRepository,
      //   ),
      //   child: AppView(),
      // ),
  }
}
class HomePageView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: "HOME",
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
            child: Column(
            children: <Widget>[
            Expanded(
              child: _ListarHabitacionWidget().build(context)
            ),
            Expanded(
              child: _DispositivosInactivosWidget().build(context)
            )
          ],
        )),
      )
    );
  }


}

/*ListView.builder(itemCount: ,
        )*/
/*Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user.photo),
            ),
            const SizedBox(height: 4.0),
            Text(user.email, style: textTheme.headline6),
            const SizedBox(height: 4.0),
            Text(user.name ?? '', style: textTheme.headline5),
          ],
        ),*/


class _ListarHabitacionWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white12,
                        Colors.black12,
                      ]
                  )
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/fotos/imagenListarHabitaciones.png")
                    //https://i.pinimg.com/736x/d1/2c/93/d12c9376d6fe2a9d33f2d1840ffae02c.jpg
                    // https://image.flaticon.com/icons/png/512/1375/1375683.png
                  )
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "HABITACIONES",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      shadows: <Shadow>[
                        Shadow(
                            color: Colors.white,
                            blurRadius: 50.0
                        )
                      ],
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.0
                  ),
                ),
              ),
            ),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => ListaHabitacionesPage())
            );
          },
        ),
      );
  }

}

class _DispositivosInactivosWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //shadowColor: Colors.black87,

      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white12,
                      Colors.black12,
                    ]
                )
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/fotos/imagenListarHabitaciones.png") //https://i.pinimg.com/736x/d1/2c/93/d12c9376d6fe2a9d33f2d1840ffae02c.jpg
                  //https://cdn.discordapp.com/attachments/502530393740673025/796319599842033674/fotoefectos.com_.jpg
                  // https://image.flaticon.com/icons/png/512/1375/1375683.png
                )
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "DISPOSITIVOS INACTIVOS",
                style: TextStyle(
                    fontFamily: "Raleway",
                    shadows: <Shadow>[
                      Shadow(
                          color: Colors.white,
                          blurRadius: 50.0
                      )
                    ],
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0
                ),
              ),
            ),
          ),
        ),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => DispositivosInactivosPage())
          );
        },
      ),
    );
  }



}