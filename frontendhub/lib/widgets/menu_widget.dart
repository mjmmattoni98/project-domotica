import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:devices_repository/devices_repository.dart';

typedef NombreCallback = void Function(String nombre, TipoDispositivo tipo);

class  MenuWidget extends StatefulWidget {
  const MenuWidget({this.callback});

  final NombreCallback callback;

  @override
  _MenuWidget createState() => _MenuWidget();
}

class  _MenuWidget extends State<MenuWidget> {
  final List<bool> isSelected = [true, false, false];
  int lastSelected = 0;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
      ),
      child: Container(
        color: Colors.black87,
        width: width,
        height: height/3 + 55,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.keyboard_arrow_up,
              size: 20,
              color: Colors.white70,
            ),
            Text("Añadir dispositivo",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 20.0,
                  color: Colors.white70
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: width/9, right: width/9, top: height/19),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TextField(
                      // Para introducir el nuevo nombre del dispositivo
                      controller: textController,
                      cursorColor: Colors.black87,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Raleway"
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  Container(
                    child: ToggleButtons(
                      // Botones para seleccionar el estado del dispositivo,
                      // por default esta seleccionado Alarma
                      children: <Widget>[
                        Text("Alarma",
                          style: TextStyle(
                              fontFamily: "Raleway",
                          ),
                        ),
                        Text("Movimiento",
                          style: TextStyle(
                            fontFamily: "Raleway",
                          ),
                        ),
                        Text("Apertura",
                          style: TextStyle(
                              fontFamily: "Raleway",
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          // Nos guardamos el indice del ultimo boton seleccionado
                          lastSelected = index;
                          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                      color: Colors.white,
                      selectedColor: Colors.green,
                      // renderBorder: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: (){
                      // Cuando apretamos en Añadir, vemos cual es la ultima
                      // opcion que se ha elegido del tipo del dispositivo
                      // y vemos el nombre introducido
                      TipoDispositivo tipo;
                      switch(lastSelected){
                        case 0:
                          tipo = TipoDispositivo.ALARMA;
                          break;
                        case 1:
                          tipo = TipoDispositivo.DETECTOR_DE_MOVIMIENTO;
                          break;
                        case 2:
                          tipo = TipoDispositivo.SENSOR_DE_APERTURA;
                          break;
                      }
                      String name = textController.value.text;
                      widget.callback(name, tipo);
                      textController.clear();
                    },
                    elevation: 10.0,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Añadir",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            color: Colors.white70
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
