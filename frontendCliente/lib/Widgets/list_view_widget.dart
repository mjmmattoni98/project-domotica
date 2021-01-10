import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:room_repository/room_repository.dart';


class ListViewWidget extends StatelessWidget {

  final AsyncSnapshot snapshot;

  ListViewWidget(this.snapshot) : assert (snapshot != null);

  Widget build(BuildContext context) {
    //List<Room> roomList = Provider.of<List<Room>>(context);

    //FirebaseServices firebaseServices = FirebaseServices();


      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: BouncingScrollPhysics( parent: AlwaysScrollableScrollPhysics() ),

              itemCount: snapshot.data.length,
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
                          onPressed: (){},
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(title: Text("Cambiar nombre"), onPressed: (){}, trailingIcon: Icon(Icons.update)),
                            FocusedMenuItem(title: Text("Eliminar", style: TextStyle(color: Colors.white),), onPressed: (){}, trailingIcon: Icon(Icons.delete), backgroundColor: Colors.redAccent)
                          ],
                          child: ListTile(


                            title: Text(snapshot.data[index].nombre, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),),
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
}