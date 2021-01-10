import 'package:bloc/bloc.dart';
import 'package:room_repository/room_repository.dart';

import 'habitacion_event.dart';
import 'habitacion_state.dart';


class HabitacionBloc
    extends Bloc<HabitacionEvent, HabitacionState> {

  final RoomRepository roomRepository;

  HabitacionState get initialState => ListaCargando();

  HabitacionBloc(HabitacionState initialState, this.roomRepository) : super(initialState);


  //HabitacionBloc(HabitacionState initialState) : super(initialState);


  @override
  Stream<HabitacionState> mapEventToState(HabitacionEvent event) async*{
    yield ListaCargando();
    /*switch(event){
      case CambiarNombreHabitacion{

      }
    }*/

    if(event is CambiarNombreHabitacion){
      try{
        final List<Room> list = await roomRepository.getRoomList().single;
        yield ListaCargando();
        yield cambiarNombreHabitacion(list, event.nuevoNombre, event.habitacion);
      }on Error{
        yield ListaError("INTERNET_CONNECTION");
      }
    }
  }

  HabitacionState cambiarNombreHabitacion(List<Room> habitaciones, String nuevoNombre, Room habitacion){
    //for(var i = 0; i < habitaciones.length)
    habitaciones.forEach((element) { if(element.nombre.toLowerCase() == nuevoNombre){ return ListaError("REPEATED_ELEMENT"); } });
    Future<void> f = roomRepository.changeName(habitacion, nuevoNombre);
    f.timeout(Duration(seconds: 20));
    return ListaCargada(habitaciones);
  }


}



