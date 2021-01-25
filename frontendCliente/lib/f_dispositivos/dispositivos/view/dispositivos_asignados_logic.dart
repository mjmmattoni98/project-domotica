import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/dispositivos.dart';
import 'package:room_repository/room_repository.dart';
import 'package:room_repository/device_repository.dart';

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
             addAutomaticKeepAlives: true,
             physics: BouncingScrollPhysics( parent: AlwaysScrollableScrollPhysics() ),
             itemCount: state.dispositivos.length,
             itemBuilder: (_, int index) {
               return Padding(
                 padding: EdgeInsets.all(5.0),
                 child: Container(
                   child: Card(
                     elevation: 10.0,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0)
                     ),
                     child: FocusedMenuHolder(
                       blurBackgroundColor: Colors.white38,
                       blurSize: 2.0,
                       animateMenuItems: true,
                       openWithTap: true,
                       onPressed: () {},
                       menuItems: <FocusedMenuItem>[
                         FocusedMenuItem(
                             trailingIcon: Icon(
                               Icons.assignment_return_outlined,
                             ),
                             title: Text(
                               "Desasignar dispositivo",
                               style: TextStyle(
                                   fontFamily: "Raleway"
                               ),
                             ),
                             onPressed: () {
                                context.bloc<DispositivoBloc>().add(DesasignarDispositivo(state.dispositivos[index]));
                             }
                         )
                       ],
                       child: SwitchListTile(
                         title: Text(state.dispositivos[index].nombre,
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             fontWeight: FontWeight.w500,
                             fontSize: 20.0,
                             fontFamily: "Raleway",
                           ),
                         ),
                         value: state.dispositivos[index].estado == Estado.ACTIVE ? true : false,
                         onChanged: state.dispositivos[index].estado == Estado.DISCONNECTED ? null : (bool value){
                           Estado nuevoEstado = value ? Estado.ACTIVE : Estado.INACTIVE;
                           modificarEstadoDispositivo(context, state.dispositivos[index], nuevoEstado);
                         },
                         secondary: estadoDispositivo(state.dispositivos[index]),
                       ),
                       // ListTile(
                       //   title: Text(state.dispositivos[index].nombre, textAlign: TextAlign.center,
                       //   style: TextStyle(
                       //       fontWeight: FontWeight.w500, fontSize: 20.0, fontFamily: "Raleway"),
                       //   ),
                       //   )
                       ),

                     ),
                   ),
                 );
             },
           );
         }if(state is DispositivosInitial){
           context.bloc<DispositivoBloc>().add(DispositivosStarted(habitacionActual));
         }if(state is DispositivosListaError){
           return Center(child: Text("No hay dispositivos asignados a esta habitación", style: TextStyle(
             fontFamily: "Raleway"
           ), textAlign: TextAlign.center,),);
         }
         return Center(child: CircularProgressIndicator());
        }
    );
  }

  Widget estadoDispositivo(Device device){
    Text text = Text("No se ha podido establecer el estado del dispositivo");
    switch(device.estado) {
      case Estado.ACTIVE:
        text = Text(
          device.estadoActual,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            fontFamily: "Raleway",
            color: Colors.green,
          ),
        );
        break;
      case Estado.INACTIVE:
        text = Text(
          device.estadoActual,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            fontFamily: "Raleway",
            color: Colors.black38,
          ),
        );
        break;
      case Estado.DISCONNECTED:
        text = Text(
          device.estadoActual,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            fontFamily: "Raleway",
            color: Colors.grey,
          ),
        );
        break;
    }
    return text;
  }

  void modificarEstadoDispositivo(BuildContext context, Device dispositivo, Estado estado){
    context.bloc<DispositivoBloc>().add(CambiarEstadoDispositivo(dispositivo, estado));
  }

}