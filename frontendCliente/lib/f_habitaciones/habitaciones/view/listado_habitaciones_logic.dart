import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendCliente/Widgets/confirmacion_alert.dart';
import 'package:frontendCliente/f_dispositivos/dispositivos/view/dispositivos_asignados_page.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_bloc.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_event.dart';
import 'package:frontendCliente/f_habitaciones/habitaciones/bloc/habitacion_state.dart';
import 'package:room_repository/room_repository.dart';
import 'package:frontendCliente/Widgets/menu_widget.dart';

class ListaHabitacionesLogic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListaHabitacionesLogicState();
  }

}

class _ListaHabitacionesLogicState extends State<ListaHabitacionesLogic>{
  bool showBottomMenu = false;
  TextEditingController controladorNombre = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var threshold = 100;
    return BlocListener<HabitacionBloc, HabitacionState>(
        listener: (context, state){
          if(state is ListaError){
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.mensaje)),
              );
          }
        },
      child: GestureDetector(
        onPanEnd: (details){
          if(details.velocity.pixelsPerSecond.dy > threshold){
            this.setState(() {
              showBottomMenu = false;
            });
          }
          else if(details.velocity.pixelsPerSecond.dy < -threshold){
            this.setState(() {
              showBottomMenu = true;
            });
          }
        },
        child: Stack(
          children: <Widget>[
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
                    listadoInicial(context);
                  }else if(state is HabitacionModificada){
                    listadoInicial(context);
                  }else if(state is ListaError){
                    print("ERROR PRIM");
                    listadoInicial(context);
                  }else if(state is HabitacionAnadida){
                    print("LEGGO");
                    listadoInicial(context);
                  }else if(state is EsperandoConfirmacion){
                    createConfirmDialog(context, state.habitacion);
                  }else if(state is HabitacionEliminada){
                    listadoInicial(context);
                  }
                  print("Liada loko");
                  return buildCargando();
                }
            ),
            AnimatedPositioned(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 800),
              child: MenuWidget(
                callback: (String nombre){
                  anadirHabitacion(context, nombre);
                },
              ),
              left: 0.0,
              bottom: (showBottomMenu)?0:-(height/3),
            ),
          ],
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
        Flexible(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (context) => DispositivosAsignadosPage(habitaciones[index]))
                            );
                          },
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(title: Text("Cambiar nombre", style: TextStyle(fontFamily: "Raleway"),), onPressed: (){
                              createAlertDialog(context, habitaciones[index], controladorNombre);
                            }, trailingIcon: Icon(Icons.update)),
                            FocusedMenuItem(title: Text("Eliminar", style: TextStyle(color: Colors.white, fontFamily: "Raleway"),), onPressed: (){
                              eliminarHabitacion(context, habitaciones[index], false);
                            }, trailingIcon: Icon(Icons.delete), backgroundColor: Colors.redAccent)
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
  void listadoInicial(BuildContext context){
    context.bloc<HabitacionBloc>().add(ActualizarListarHabitaciones());
  }
  void modificarHabitacion(BuildContext context, Room habitacion){
    context.bloc<HabitacionBloc>().add(CambiarNombreHabitacion(habitacion, controladorNombre.text));
  }

  void anadirHabitacion(BuildContext context, String habitacion){
    context.bloc<HabitacionBloc>().add(AnadirHabitacion(habitacion));
  }

  void eliminarHabitacion(BuildContext context, Room habitacion, bool confirmacion){
    context.bloc<HabitacionBloc>().add(EliminarHabitacion(habitacion, confirmacion));
  }

  createConfirmDialog(BuildContext context, Room habitacion){
    return showDialog(
      context: context, builder: (_){
      return ConfirmationAlert(
        callback: (bool confirmacion){
          eliminarHabitacion(context, habitacion, confirmacion);
        },
      );
      }
    );
  }

  createAlertDialog(BuildContext context, Room habitacion, TextEditingController controller){
    return showDialog(context: context, builder: (_){
      return AlertDialog(
        elevation: 10.0,
        title: Text("Nuevo nombre para esta habitacion",
          style: TextStyle(fontFamily: "Raleway"),
          textAlign: TextAlign.center,
        ),
        content: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Raleway",
          ),
          controller: controller,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 10.0,
            child: Text("Cambiar"),
            onPressed: (){
              modificarHabitacion(context, habitacion);
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }
}