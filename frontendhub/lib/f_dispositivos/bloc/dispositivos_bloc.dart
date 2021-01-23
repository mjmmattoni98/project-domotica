import 'dart:async';

import 'package:devices_repository/devices_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'dispositivos_event.dart';
part 'dispositivos_state.dart';

class DispositivosBloc
    extends Bloc<DispositivosEvent, DispositivosState> {

  DispositivosBloc({
    @required DeviceRepository deviceRepository,
  })  : assert(deviceRepository != null),
        _deviceRepository = deviceRepository,
        super(const DispositivosInitial());

  final DeviceRepository _deviceRepository;

  DispositivosState get initialState => DispositivosInitial();

  @override
  Stream<DispositivosState> mapEventToState(DispositivosEvent event) async*{
    if (event is ActualizarListaDispositivos){
      yield DispositivosCargando();
      final List<Device> devices = await _deviceRepository.getDevicesAct();
      yield DispositivosModificados(devices);
    }
    else if (event is CambiarNombreDispositivo){
      yield DispositivosCargando();
      final List<Device> devices = await _deviceRepository.getDevicesAct();
      final DispositivosState estadoGenerado = await cambiarNombreDispositivo(devices, event.nuevoNombre, event.device.name);
      yield estadoGenerado;
    }
    else if (event is CambiarEstadoDispositivo){
      yield DispositivosCargando();
      String nuevoEstado = event.device.tipo.getEstado(event.nuevoEstado);
      await _deviceRepository.updateDeviceState(event.device.name, nuevoEstado);
      yield DispositivoModificado("Dispositivo modificado con éxito");
    }
    else if (event is CambiarEstadoHub){
      yield DispositivosCargando();
      final List<Device> devices = await _deviceRepository.getDevicesAct();
      await cambiarEstadoDispositivos(devices, event.nuevoEstado);
      yield DispositivoModificado("Dispositivo modificado con éxito");
    }
    else if(event is AddDispositivo){
      yield DispositivosCargando();
      final List<Device> list = await _deviceRepository.getDevicesAct();
      final DispositivosState estadoGenerado = await crearDispositivo(list, event.nombre, event.tipo);
      yield estadoGenerado;
    }
    else if(event is RemoveDispositivo){
      yield DispositivosCargando();
      final List<Device> list = await _deviceRepository.getDevicesAct();
      final DispositivosState estadoGenerado = await eliminarHabitacion(list, event.nombre, event.confirmacion);
      yield estadoGenerado;
    }
    else if(event is CrearDispositivosDefault){
      yield DispositivosCargando();
      await _deviceRepository.createDefaultDevices();
    }
  }

  Future<void> cambiarEstadoDispositivos(List<Device> dispositivos, Estado estado) async{
    dispositivos.forEach((device) async{
      String nuevoEstado = device.tipo.getEstado(estado);
      await _deviceRepository.updateDeviceState(device.name, nuevoEstado);
    });
  }

  Future<DispositivosState> cambiarNombreDispositivo(List<Device> dispositivos, String nuevoNombre, String antiguoNombre) async {
    for(var i = 0; i < dispositivos.length; i++){
      if(dispositivos[i].name.toLowerCase() == nuevoNombre.toLowerCase()){
        return DispositivosError("Ya hay un dispositivo con ese nombre");
      }
    }
    await _deviceRepository.updateDeviceName(antiguoNombre, nuevoNombre);
    return DispositivoModificado("Dispositivo modificado con éxito");
  }

  Future<DispositivosState> crearDispositivo(List<Device> dispositivos, String name, TipoDispositivo tipo) async{
    for(var i = 0; i < dispositivos.length; i++){
      if(dispositivos[i].name.toLowerCase() == name.toLowerCase()){
        return DispositivosError("Ya hay un dispositivo con ese nombre");
      }
    }
    Device device = Device(name: name, tipo: tipo);
    await _deviceRepository.createDevice(device);
    return DispositivoAnyadido("Dispositivo añadido correctamente");
  }

  Future<DispositivosState> eliminarHabitacion(List<Device> dispositivos, String name, bool confirmacion) async{
    bool existe = false;
    for (var i = 0; i < dispositivos.length; i++) {
      if(dispositivos[i].name.toLowerCase() == name.toLowerCase()){
        existe = true;
      }
    }

    if(existe && confirmacion){ // el dispositivo existe
      await _deviceRepository.deleteDevice(name);
      print("ta guapo eh");
      return DispositivoBorrado("Dispositivo borrado correctamente");
    }else { // no existe ese dispositivo
      return DispositivosError("DISPOSITIVO_NO_EXISTENTE");
    }
  }
}