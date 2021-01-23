import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';

import 'habitacion_event.dart';
import 'habitacion_state.dart';


class HabitacionBloc
    extends Bloc<HabitacionEvent, HabitacionState> {

  final RoomRepository roomRepository;
  final DeviceRepository deviceRepository;

  HabitacionBloc(this.roomRepository, this.deviceRepository) : super(HabitacionesInitial());

  HabitacionState get initialState => HabitacionesInitial();

  @override
  Stream<HabitacionState> mapEventToState(HabitacionEvent event) async* {
    if (event is CambiarNombreHabitacion){
      yield HabitacionCargando();
      final List<Room> list = await roomRepository.getRoomListAct();
      final HabitacionState estadoGenerado = await cambiarNombreHabitacion(
          list, event.nuevoNombre, event.habitacion);
      yield estadoGenerado;
    } else if (event is ActualizarListarHabitaciones){
      yield HabitacionCargando();
      final HabitacionState estadoGenerado = await listarHabitaciones();
      yield estadoGenerado;
    } else if(event is AnadirHabitacion){
      yield HabitacionCargando();
      final List<Room> list = await roomRepository.getRoomListAct();
      final HabitacionState estadoGenerado = await crearHabitacion(list, event.nombre);
      yield estadoGenerado;
    } else if(event is EliminarHabitacion){
      yield HabitacionCargando();
      final List<Room> list = await roomRepository.getRoomListAct();
      final HabitacionState estadoGenerado = await eliminarHabitacion(list, event.habitacion, event.confirmacion);
      yield estadoGenerado;
    }
  }

  Future<HabitacionState> cambiarNombreHabitacion(List<Room> habitaciones,
      String nuevoNombre, Room habitacion) async {
    for (var i = 0; i < habitaciones.length; i++) {
      if (habitaciones[i].nombre.toLowerCase() == nuevoNombre.toLowerCase()) {
        return ListaError("REPEATED_ELEMENT");
      }
    }
    await roomRepository.changeName(habitacion, nuevoNombre);
    return HabitacionModificada("Habitacion modificada con éxito");
  }

  Future<HabitacionState> listarHabitaciones() async {
    List<Room> lista = await roomRepository.getRoomListAct();
    return HabitacionesCargadas(lista);
  }

  Future<HabitacionState> crearHabitacion(List<Room> habitaciones,
      String nombre) async {
    if(nombre == ""){
      return ListaError("Debe haber un nombre para la habitación");
    }
    for (var i = 0; i < habitaciones
        .length; i++) { // Comprobamos si la habitacion que queremos crear
      if (habitaciones[i].nombre.toLowerCase() ==
          nombre.toLowerCase()) { // ya existe
        return ErrorHabitacionExistente("Esta habitación ya existe");
      }
    }
    await roomRepository.createRoom(nombre);
    return HabitacionAnadida("Habitacion añadida correctamente");
  }

  Future<HabitacionState> eliminarHabitacion(List<Room> habitaciones,
      Room habitacion, bool confirmacion) async{
    print(habitacion.nombre);
    bool existe = false;
    for (var i = 0; i < habitaciones.length; i++) { // Comprobamos si la habitacion que queremos crear
      if(habitaciones[i].nombre.toLowerCase() == habitacion.nombre.toLowerCase()){
        existe = true;
      }
    }

    List<Device> dispositivos = await deviceRepository.getDevicesInRoom(habitacion).first;




    if(existe){ // la habitacion existe
      if(dispositivos.length > 0 && confirmacion) { // tiene dispositivos y se confirma su eliminacion
        await roomRepository.deleteRoom(habitacion);
        print("ta guapo eh");
        return HabitacionEliminada("Habitación borrada correctamente");
      }else if(dispositivos.length > 0 && !confirmacion) { // tiene dispositivos pero aun no se ha
        print("Que pasa prim");// confirmado su eliminacion
        return HabitacionConDispositivos();
      }else if(dispositivos.length == 0) { // la habitacion no tiene dispositivos
        print("Ta guapo no?");
        await roomRepository.deleteRoom(habitacion);
        return HabitacionEliminada("La habitación se ha borrado correctamente");
      }
    }else { // no existe esa habitacion
      return ListaError("HABITACION_NO_EXISTENTE");
    }
  }
}
