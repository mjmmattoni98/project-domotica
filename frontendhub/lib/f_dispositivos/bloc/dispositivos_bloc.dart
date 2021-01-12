import 'dart:async';

import 'package:devices_repository/devices_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'dispositivos_event.dart';
part 'dispositivos_state.dart';

class DispositivosBloc
    extends Bloc<DispositivosEvent, DispositivosState> {

  DispositivosBloc({
    @required DeviceRepository deviceRepository,
  })  : assert(deviceRepository != null),
        _deviceRepository = deviceRepository,
        super(const DispositivosInitial()) ;

  final DeviceRepository _deviceRepository;

  @override
  Stream<DispositivosState> mapEventToState(DispositivosEvent event) async*{
    String uid = await _deviceRepository.hubUid.single;
    if(event is CambiarNombreDispositivo){
      try{
        yield DispositivosCargando();
        final List<Device> dispositivos = await _deviceRepository.getDevices(uid);
        final DispositivosState estadoGenerado = await cambiarNombreDispositivo(dispositivos, event.nuevoNombre, event.device.name, uid);
        yield estadoGenerado;
      }on Error{
        yield DispositivosError("INTERNET_CONNECTION");
      }
    }else if(event is ActualizarListarDispositivos){
      yield DispositivosCargando();
      final DispositivosState estadoGenerado = await listarDispositivos(uid);
      yield estadoGenerado;
    }
  }

  Future<DispositivosState> cambiarNombreDispositivo(List<Device> dispositivos, String nuevoNombre, String antiguoNombre, String uid) async {
    for(var i = 0; i < dispositivos.length; i++){
      if(dispositivos[i].name.toLowerCase() == nuevoNombre.toLowerCase()){
        return DispositivosError("REPEATED_ELEMENT");
      }
    }
    await _deviceRepository.updateDeviceName(uid, antiguoNombre, nuevoNombre);
    return DispositivoModificado("Dispositivo modificado con éxito");
  }

  Future<DispositivosState> listarDispositivos(String uid) async {
    List<Device> lista =  await _deviceRepository.getDevices(uid);
    return DispositivosCargados(lista);
  }

  Future<DispositivosState> crearDispositivo(List<Device> dispositivos, String nombre) async{
    for(var i = 0; i < dispositivos.length; i++){
      if(dispositivos[i].name.toLowerCase() == nombre.toLowerCase()){
        return DispositivosError("REPEATED_ELEMENT");
      }
    }
    await _deviceRepository.createDevice(nombre);
    return DispositivoAnyadido("Dispositivo añadido correctamente");
  }
}