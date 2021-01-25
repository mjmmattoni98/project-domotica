import 'package:flutter/material.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos_inactivos/dispositivos_inactivos.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/listado_habitaciones.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return HomePageView();
  }
}
class HomePageView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

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
            // Navigator.of(context).push<void>(ListaHabitacionesPage.route());
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
                    image: AssetImage("assets/fotos/imagenListarHabitaciones.png"),
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
          // Navigator.of(context).push<void>(DispositivosInactivosPage.route());
        },
      ),
    );
  }
}