import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_repository/room_repository.dart';

import 'habitacion_event.dart';
import 'habitacion_state.dart';


class HabitacionBloc
    extends Bloc<HabitacionEvent, HabitacionState> {

  final RoomRepository roomRepository;

  HabitacionBloc(this.roomRepository) : super(HabitacionesInitial());
  HabitacionState get initialState => HabitacionesInitial();



  @override
  Stream<HabitacionState> mapEventToState(HabitacionEvent event) async*{
    if(event is CambiarNombreHabitacion){
      try{
        yield HabitacionCargando();
        final List<Room> list = await roomRepository.getRoomListAct();
        final HabitacionState estadoGenerado = await cambiarNombreHabitacion(list, event.nuevoNombre, event.habitacion);
        yield estadoGenerado;
      }on Error{
        yield ListaError("INTERNET_CONNECTION");
      }
    }else if(event is ActualizarListarHabitaciones){
      yield HabitacionCargando();
      final HabitacionState estadoGenerado = await listarHabitaciones();
      yield estadoGenerado;/*HabitacionesInitial(roomRepository.getRoomListAct());*/
    }
  }

  Future<HabitacionState> cambiarNombreHabitacion(List<Room> habitaciones, String nuevoNombre, Room habitacion) async {
    //for(var i = 0; i < habitaciones.length)
    habitaciones.forEach((element) { if(element.nombre.toLowerCase() == nuevoNombre){ return ListaError("REPEATED_ELEMENT"); } });
    await roomRepository.changeName(habitacion, nuevoNombre);
    return HabitacionModificada("Habitacion modificada con éxito");
    //f.timeout(Duration(seconds: 20));
    //return HabitacionInitial();
  }

  Future<HabitacionState> listarHabitaciones() async {
    List<Room> lista =  await roomRepository.getRoomListAct();
    return HabitacionesCargadas(lista);
  }
}



