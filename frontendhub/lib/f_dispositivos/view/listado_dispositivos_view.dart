import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:frontendhub/widgets/confirmation_alert.dart';
import 'package:frontendhub/f_dispositivos/dispositivos.dart';
import 'package:devices_repository/devices_repository.dart';
import 'package:frontendhub/widgets/menu_widget.dart';

class ListadoDispositivosView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ListadoDispositivosViewState();
  }
}

class _ListadoDispositivosViewState extends State<ListadoDispositivosView> {
  bool showBottomMenu = false;
  // bool encendido = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    const threshold = 50;
    return BlocListener<DispositivosBloc, DispositivosState>(
      listener: (context, state) {
        if (state is DispositivosError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.mensaje)),
            );
        }else if (state is DispositivoInexistente) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("El dispositivo que se intenta eliminar no existe.")),
            );
        }else if (state is DispositivoNombreRepetido) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("El nombre del dispositivo ya existe")),
            );
        }
      },
      child: GestureDetector(
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy > threshold) {
            this.setState(() {
              showBottomMenu = false;
            });
          }
          else if (details.velocity.pixelsPerSecond.dy < -threshold) {
            this.setState(() {
              showBottomMenu = true;
            });
          }
        },
        child: Stack(
          children: <Widget>[
            BlocBuilder<DispositivosBloc, DispositivosState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state){
                  if(state is DispositivosCargando){
                    return Cargando();
                  }else if(state is DispositivosModificados){
                    if(state.devices.isEmpty)
                      return NoHayDispositivos();
                    return BuildListado(state.devices);
                  }else if (state is DispositivosError){
                    return ErrorListarDispositivos(state.mensaje);
                  } else if (state is DispositivosInitial) {
                    context
                        .bloc<DispositivosBloc>()
                        .add(DispositivosStarted());
                  }
                  // actualizarListaDispositivos(context);
                  return Cargando();
                },
            ),
            AnimatedPositioned(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 800),
              child: MenuWidget(
                callback: (String nombre, TipoDispositivo tipo) {
                  anadirDispositivo(context, nombre, tipo);
                },
              ),
              left: 0.0,
              bottom: showBottomMenu ? 0 : -(height / 3),
              // top: showBottomMenu ? -(height / 3): 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget estadoHub(bool encendido){
    Text text;
    if(encendido){
      text = Text(
        "ENCENDIDO",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: "Raleway",
          color: Colors.green,
        ),
      );
    }
    else{
      text = Text(
        "APAGADO",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: "Raleway",
          color: Colors.red,
        ),
      );
    }
    return text;
  }

  void anadirDispositivo(BuildContext context, String nombre, TipoDispositivo tipo){
    context.bloc<DispositivosBloc>().add(AddDispositivo(nombre, tipo));
  }

  // void actualizarListaDispositivos(BuildContext context){
  //   context.bloc<DispositivosBloc>().add(ActualizarListaDispositivos());
  // }

  void cambiarEstadoHub(BuildContext context, Estado estado){
    context.bloc<DispositivosBloc>().add(CambiarEstadoHub(estado));
  }
}

class NoHayDispositivos extends StatelessWidget{
  final String mensajeCrearDefault = "¿Quieres crear dispositivos default? Se creará un dispositivo de cada tipo";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(mensajeCrearDefault,
            style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 15.0,
            ),
          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
        ),
        yesButton(context, "SI"),
      ],
    );
  }

  Widget yesButton(BuildContext context, String mensaje){
    return RaisedButton(
      child: Text(mensaje,
        style: TextStyle(
          fontFamily: "Raleway",
          color: Colors.green,
          fontSize: 15.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: () => context.read<DispositivosBloc>().add(CrearDispositivosDefault()),
    );
  }

  void crearDispositivosDefault(BuildContext context, bool confirmacion){
    if(confirmacion){
      context.read<DispositivosBloc>().add(CrearDispositivosDefault());
    }
  }

  createConfirmDialogCreateDefault(BuildContext context, String mensaje){
    return showDialog(context: context, builder: (_){
      return ConfirmationAlert(
        callback: (bool confirmacion){
          crearDispositivosDefault(context, confirmacion);
        },
        mensaje: mensaje,
      );
    });
  }
}

class ErrorListarDispositivos extends StatelessWidget{
  const ErrorListarDispositivos(this.mensaje);

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return createErrorDialog(context, mensaje);
  }

  createErrorDialog(BuildContext context, String mensaje){
    return showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            elevation: 10.0,
            title: Text(mensaje,
              style: TextStyle(fontFamily: "Raleway"),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 10.0,
                child: Text("OK"),
                onPressed: (){
                  // actualizarListaDispositivos(context);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  // void actualizarListaDispositivos(BuildContext context){
  //   context.bloc<DispositivosBloc>().add(ActualizarListaDispositivos());
  // }
}

class Cargando extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class BuildListado extends StatelessWidget{
  BuildListado(this.devices);

  final List<Device> devices;
  final TextEditingController controladorNombre = TextEditingController();
  final String mensajeEliminar = "¿Estás seguro de que deseas eliminar el dispositivo?";
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                addAutomaticKeepAlives: true,
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),

                itemCount: devices.length,
                itemBuilder: (_, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 5,
                        child: InkWell(
                          child: FocusedMenuHolder(
                            blurBackgroundColor: Colors.white38,
                            blurSize: 2.0,
                            animateMenuItems: true,
                            onPressed: () {},
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  title: Text("Cambiar nombre",
                                    style: TextStyle(
                                        fontFamily: "Raleway"),
                                  ),
                                  onPressed: () {
                                    createAlertDialog(
                                        context, devices[index],
                                        controladorNombre);
                                  },
                                  trailingIcon: Icon(Icons.update)
                              ),
                              FocusedMenuItem(
                                  title: conexion(devices[index]),
                                  onPressed: () {
                                    Estado nuevoEstado = devices[index].estado == Estado.DISCONNECTED ? Estado.INACTIVE : Estado.DISCONNECTED;
                                    modificarEstadoDispositivo(context, devices[index], nuevoEstado);
                                  },
                                  trailingIcon: Icon(Icons.update)
                              ),
                              FocusedMenuItem(
                                title: Text("Eliminar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Raleway"
                                  ),
                                ),
                                onPressed: () {
                                  createConfirmDialogDelete(
                                      context, devices[index],
                                      mensajeEliminar);
                                },
                                trailingIcon: Icon(Icons.delete),
                                backgroundColor: Colors.redAccent,
                              )
                            ],
                            child: SwitchListTile(
                              title: Text(devices[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                  fontFamily: "Raleway",
                                ),
                              ),
                              value: devices[index].estado == Estado.ACTIVE ? true : false,
                              onChanged: devices[index].estado == Estado.DISCONNECTED ? null : (bool value){
                                Estado nuevoEstado = value ? Estado.ACTIVE : Estado.INACTIVE;
                                modificarEstadoDispositivo(context, devices[index], nuevoEstado);
                              },
                              secondary: estadoDispositivo(devices[index]),
                            ),
                          ),
                          // onTap: (){
                          // },
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

  Widget conexion(Device device){
    Text text = Text("No se ha podido establecer la conexion del dispositivo");
    if(device.estado == Estado.DISCONNECTED){
      text = Text(
        "CONECTAR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: "Raleway",
          color: Colors.green,
        ),
      );
    }
    else{
      text = Text(
        "DESCONECTAR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: "Raleway",
          color: Colors.red,
        ),
      );
    }
    return text;
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
    context.bloc<DispositivosBloc>().add(CambiarEstadoDispositivo(dispositivo, estado));
  }

  void modificarDispositivo(BuildContext context, Device dispositivo){
    context.bloc<DispositivosBloc>().add(CambiarNombreDispositivo(dispositivo, controladorNombre.text));
  }

  void eliminarDispositivo(BuildContext context, Device dispositivo){
    context.bloc<DispositivosBloc>().add(RemoveDispositivo(dispositivo.id));
  }

  createConfirmDialogDelete(BuildContext context, Device dispositivo, String mensaje){
    return showDialog(context: context, builder: (_){
      return ConfirmationAlert(
        callback: (bool confirmacion){
          if(confirmacion)
            eliminarDispositivo(context, dispositivo);
        },
        mensaje: mensaje,
      );
    });
  }

  createAlertDialog(BuildContext context, Device dispositivo, TextEditingController controller){
    return showDialog(context: context, builder: (_){
      return AlertDialog(
        elevation: 10.0,
        title: Text("Nuevo nombre para este dispositivo",
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
              modificarDispositivo(context, dispositivo);
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }
}