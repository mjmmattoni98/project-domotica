import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_bloc.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_event.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/bloc/dispositivos_state.dart';
import 'package:room_repository/room_repository.dart';

class DispositivosAsignadosLogic extends StatefulWidget{
  final Room habitacionActual;

  const DispositivosAsignadosLogic(this.habitacionActual);
  @override
  State<StatefulWidget> createState() {
    return _DispositivosAsignadosLogicState(habitacionActual);
  }
}


class _DispositivosAsignadosLogicState extends State<DispositivosAsignadosLogic>{
  final Room habitacionActual;

  _DispositivosAsignadosLogicState(this.habitacionActual);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DispositivoBloc, DispositivoState>(
        builder: (context, state){
         if(state is DispositivosActuales) {
           return ListView.builder(
             itemCount: state.dispositivos.length,
             itemBuilder: (_, int index) {
               return Padding(
                 padding: EdgeInsets.all(5.0),
                 child: Container(
                   child: Card(
                     elevation: 10.0,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0)),
                     child: FocusedMenuHolder(
                       blurBackgroundColor: Colors.white38,
                       blurSize: 2.0,
                       animateMenuItems: true,
                       openWithTap: true,
                       onPressed: () {},
                       menuItems: <FocusedMenuItem>[
                         FocusedMenuItem(
                             trailingIcon: Icon(
                                 Icons.assignment_return_outlined),
                             title: Text(
                               "Desasignar dispositivo",
                               style: TextStyle(
                                   fontFamily: "Raleway"
                               ),
                             ),
                             onPressed: () {

                             }
                         )
                       ],

                       child: ListTile(
                         title: Text(state.dispositivos[index].nombre, textAlign: TextAlign.center,
                         style: TextStyle(
                             fontWeight: FontWeight.w500, fontSize: 20.0, fontFamily: "Raleway"),
                         ),
                         )
                       ),

                     ),
                   ),
                 );
             },
           );
         }if(state is DispositivosInitial){
           context.bloc<DispositivoBloc>().add(DispositivosStarted(habitacionActual));
         }
         return Center(child: CircularProgressIndicator());
        }
    );
  }



}