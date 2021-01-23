import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontendhub/f_dispositivos/dispositivos.dart';

class ListadoDispositivosPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ListadoDispositivosPageState();
  }
}
class _ListadoDispositivosPageState extends State<ListadoDispositivosPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: ListadoDispositivosView(),
      );
  }
}



