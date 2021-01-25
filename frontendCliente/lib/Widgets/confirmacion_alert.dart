import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ConfirmationCallback = void Function(bool confirmacion);

class ConfirmationAlert extends StatelessWidget{
  const ConfirmationAlert({this.callback, this.mensaje});
  final String mensaje;
  final String defualtMensaje = "Esta habitación tiene dispositivos asignados.\n"
      "¿Quieres borrarla igualmente?";
  final ConfirmationCallback callback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10.0,
      title: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Raleway"),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 10.0,
          onPressed: () {
            Navigator.pop(context);
            callback(true);
          },
          child: Icon(
              Icons.check
          ),
        ),
        MaterialButton(
          elevation: 10.0,
          onPressed: () {
            Navigator.pop(context);
            callback(false);
          },
          child: Icon(
              Icons.clear_rounded
          ),
        )
      ],
    );
  }

}