import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:room_repository/device_repository.dart';
import 'package:room_repository/room_repository.dart';
import 'package:equatable/equatable.dart';

part 'habitacion_event.dart';
part 'habitacion_state.dart';

class HabitacionBloc
    extends Bloc<HabitacionEvent, HabitacionState> {

  final RoomRepository roomRepository;
  final DeviceRepository deviceRepository;
  StreamSubscription _subscription;
  List<Room> habitacionesActuales;


  HabitacionBloc(this.roomRepository, this.deviceRepository) : super(HabitacionesInitial());

  HabitacionState get initialState => HabitacionesInitial();


  /**
   * Corregir ::
   * 
   * No es necesario generar tantos estados (sobra habitación cargando),
   * deberíamos de utilizar otro "OBSERVER" como en los dispositivos y en el 
   * segundo cliente (hub).
   * 
   */
  @override
  Stream<HabitacionState> mapEventToState(HabitacionEvent event) async* {
    if(event is HabitacionesStarted){
      _subscription?.cancel();
      _subscription = roomRepository.getRoomList().listen((event) {add(HabitacionesListadas(event));});
    }
    if (event is CambiarNombreHabitacion){
      yield await cambiarNombreHabitacion(
          habitacionesActuales, event.nuevoNombre, event.habitacion);
    } else if (event is HabitacionesListadas){
      if(event.habitaciones.length == 0)
        yield ListaError("No existen habitaciones");
      else {
        habitacionesActuales = event.habitaciones;
        yield HabitacionesActuales(event.habitaciones);
      }
    } else if(event is AnadirHabitacion){
      yield await crearHabitacion(habitacionesActuales, event.nombre);
    } else if(event is EliminarHabitacion){
      yield await eliminarHabitacion(habitacionesActuales, event.habitacion, event.confirmacion);
    }
  }

  Future<List<Room>> roomStreamToList() async{
    List<Room> result = <Room>[];
    //Future<List<Room>>();
    await roomRepository.getRoomList().listen(
        (List<Room> room) {
          result = room;
        },
        onDone:(){
          return result;
        });
    return Future<List<Room>>.value(result);
  }

  Future<List<Device>> deviceStreamToList(Room habitacion) async{
    //List<Device> dev = <Device>[];
    Completer<List<Device>> com = Completer<List<Device>>();
    deviceRepository.getDevicesInRoom(habitacion).listen((event) {if(!com.isCompleted) com.complete(event);});

    return com.future;
  }

  Future<HabitacionState> cambiarNombreHabitacion(List<Room> habitaciones,
      String nuevoNombre, Room habitacion) async {
    if(nuevoNombre == ""){
      return HabitacionSinNombre();
    }
    for (var i = 0; i < habitaciones.length; i++) {
      if (habitaciones[i].nombre.toLowerCase() == nuevoNombre.toLowerCase()) {
        return HabitacionRepetida();
      }
    }
    await roomRepository.changeName(habitacion, nuevoNombre);
    return HabitacionModificada("Habitacion modificada con éxito");
  }



  Future<HabitacionState> crearHabitacion(List<Room> habitaciones,
      String nombre) async {
    if(nombre == ""){
      return HabitacionSinNombre();
    }
    print(habitaciones);
    for (var i = 0; i < habitaciones.length; i++) { // Comprobamos si la habitacion que queremos crear
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
    bool existe = false;
    for (var i = 0; i < habitaciones.length; i++) { // Comprobamos si la habitacion que queremos crear existe
      if(habitaciones[i].nombre.toLowerCase() == habitacion.nombre.toLowerCase()){
        existe = true;
      }
    }

    // List<List<Device>> dispositivosX = await deviceStreamToList(habitacion);
    // List<Device> dispositivos = dispositivosX.elementAt(0);
    List<Device> dispositivos = await deviceStreamToList(habitacion);
    print(dispositivos.length);

    if(existe){ // la habitacion existe
      if(dispositivos.length > 0 && confirmacion) { // tiene dispositivos y se confirma su eliminacion
        await roomRepository.deleteRoom(habitacion);
        await deviceRepository.desasignarHabitacionDispositivos(habitacion.id);
        return HabitacionEliminada("La habitación se ha borrado correctamente");
      }else if(dispositivos.length > 0 && !confirmacion) { // tiene dispositivos pero aun no se ha confirmado su eliminacion
        return HabitacionConDispositivos(habitacion);
      }else { // la habitacion no tiene dispositivos if(dispositivos.length == 0)
        await roomRepository.deleteRoom(habitacion);
        return HabitacionEliminada("La habitación se ha borrado correctamente");
      }
    }else { // no existe esa habitacion
      return HabitacionInexistente();
    }
  }
}
