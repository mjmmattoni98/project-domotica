import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
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
            Text("Añadir habitación",
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
                      cursorColor: Colors.black87,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Raleway"
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: (){
                      //anadirHabitacion(context, "Nueva habitacion");
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
