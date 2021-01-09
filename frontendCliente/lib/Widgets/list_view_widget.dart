

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(snapshot.data[index].nombre),
                  ),
                );
              }
            ),
          ),
        ],
      );

  }
}