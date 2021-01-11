

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:provider/provider.dart';


import 'package:room_repository/room_repository.dart';

class ListaHabitacionesPage extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ListaHabitacionesPage());
  }
  @override
  Widget build(BuildContext context) {
    return _ListaHabitacionesPageState().build(context);
  }
}
class _ListaHabitacionesPageState{
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
        ),child:
          BlocBuilder<HabitacionBloc, HabitacionState>(
            builder: (context, state){
              if(state is HabitacionCargando){
                return buildCargando();
              }else if(state is HabitacionesCargadas){
                print("Cargada");
                return buildListado(context, state.habitaciones);
              }
              else if(state is HabitacionesInitial){
                print("INITIAL");
               return buildListadoInicial(context);
              }else if(state is HabitacionModificada){
                return buildListadoInicial(context);
              }
              print("Liada loko");
              return buildListado(context, []);
            }
          ),
      ),
    );
  }



  Widget buildCargando(){
    return Center(child: CircularProgressIndicator());
  }
  Widget buildListado(BuildContext context, List<Room> habitaciones){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: BouncingScrollPhysics( parent: AlwaysScrollableScrollPhysics() ),

              itemCount: habitaciones.length,
              itemBuilder: (_, int index) {
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(

                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5,
                      child: InkWell(
                        child: FocusedMenuHolder(

                          blurBackgroundColor: Colors.white38,
                          blurSize: 2.0,

                          animateMenuItems: true,
                          onPressed: (){
                            
                          },
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(title: Text("Cambiar nombre", style: TextStyle(fontFamily: "Raleway"),), onPressed: (){
                              TextField(
                                key: const Key("Cambiar_nombre_habitacion"),
                                controller: TextEditingController(),
                                onSubmitted: (value){
                                  final habitacionBloc = context.bloc<HabitacionBloc>();
                                  habitacionBloc.add(CambiarNombreHabitacion(habitaciones[index], value));
                                },
                              );

                            }, trailingIcon: Icon(Icons.update)),
                            FocusedMenuItem(title: Text("Eliminar", style: TextStyle(color: Colors.white, fontFamily: "Raleway"),), onPressed: (){}, trailingIcon: Icon(Icons.delete), backgroundColor: Colors.redAccent)
                          ],
                          child: ListTile(
                            title: Text(habitaciones[index].nombre, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, fontFamily: "Raleway"),),
                          ),
                        ),
                        onTap: (){
                          
                        },
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
  Widget buildListadoInicial(BuildContext context){
    final habitacionBloc = context.bloc<HabitacionBloc>();
    habitacionBloc.add(ActualizarListarHabitaciones());
  }
}
