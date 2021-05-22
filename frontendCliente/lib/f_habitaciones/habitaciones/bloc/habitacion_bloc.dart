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

  Future<HabitacionState> listarHabitaciones() async {
    List<Room> lista = await roomRepository.getRoomListAct();
    if(lista.length == 0)
      return ListaError("NO HAY HABITACIONES");
    return HabitacionesCargadas(lista);
  }

  Future<HabitacionState> crearHabitacion(List<Room> habitaciones,
      String nombre) async {
    if(nombre == ""){
      return HabitacionSinNombre();
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
    for (var i = 0; i < habitaciones.length; i++) { // Comprobamos si la habitacion que queremos crear existe
      if(habitaciones[i].nombre.toLowerCase() == habitacion.nombre.toLowerCase()){
        existe = true;
      }
    }

    List<Device> dispositivos = await deviceRepository.getDevicesInRoom(habitacion).first;

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
