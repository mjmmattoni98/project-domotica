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

        color: Colors.black54,
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
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Hola loko"),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
