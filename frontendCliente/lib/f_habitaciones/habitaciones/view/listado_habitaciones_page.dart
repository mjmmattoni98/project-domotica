

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart';
import 'package:frontendCliente/Widgets/list_view_widget.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:provider/provider.dart';


import 'package:room_repository/room_repository.dart';

class ListaHabitacionesPage extends StatefulWidget{

  static Route route() {
  return MaterialPageRoute<void>(builder: (_) => ListaHabitacionesPage());
  }

  @override
  _ListaHabitacionesPageState createState() => _ListaHabitacionesPageState();
}

class _ListaHabitacionesPageState extends State<ListaHabitacionesPage>{

  List<Room> _ListaHabitaciones;

  @override
  void initState(){
    super.initState();
    _ListaHabitaciones = [];
  }


  @override
  Widget build(BuildContext context) {
    final RoomRepository roomRepository = /*Provider.of<RoomRepository>(context)*/ RoomRepository();
    //_ListaHabitaciones = roomRepository.getRoomList();

    //BlocProvider.of(context);
    //final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    // TODO: implement build
    return Scaffold(
      appBar: HomeAppBar(
        //user: user,
        title: "HABITACIONES",
        gradientBegin: Colors.black87,
        gradientEnd: Colors.black87,
        gradientMid: Colors.black54,
      ),
      body: StreamBuilder(
        stream: roomRepository.getRoomList(),//  (BuildContext context) => roomRepository.getRoomList(),
        builder: (context, AsyncSnapshot<List<Room>> snapshot){
          if(snapshot.hasData) {
            return ListViewWidget(snapshot);
          }else return Text('An error ocurred: ${snapshot.error}');
        }//ListViewWidget(),
      ),
    );
  }
  
}
