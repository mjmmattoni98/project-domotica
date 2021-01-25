import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../device_repository.dart';
import '../room_repository.dart';

/// {@template device_repository}
/// Repository which manages user devices.
/// {@endtemplate}
class DeviceRepository {
  /// {@macro device_repository}
  DeviceRepository({
    FirebaseFirestore firestore,
    FirebaseAuth auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userUid => _auth.currentUser.uid;

  Future<bool> desasignacionDispositivos(String idDispositivo) async {
    bool desasignado = false;
    await _firestore.collection('dispositivos').doc(idDispositivo)
    .get()
    .then((document) {
      if (document.exists && document.get("habitacion") != ""){
        document.reference.update({
          "habitacion": "",
        });
        desasignado = true;
      }
    })
    .catchError((err) => print("Error desasignando habitacion del dispositivo: $err"));
    return desasignado;
  }

  Future<void> desasignarHabitacionDispositivos(String idHabitacion) async{
    await _firestore.collection('dispositivos')
        .where("habitacion", isEqualTo: "")
        .get()
        .then((value) {

        });
  }

  Future<bool> asignacionDispositivos(String idDispositivo, String idHabitacion) async{
    bool asignado = false;
    await _firestore.collection('dispositivos').doc(idDispositivo)
        .get()
        .then((document) {
          if (document.exists && document.get("habitacion") == ""){
            document.reference.update({
              "habitacion": idHabitacion,
            });
            asignado = true;
      }
    })
        .catchError((err) => print("Error asignando habitacion del dispositivo: $err"));
    return asignado;
  }

  Future<void> updateDeviceState(String idDispositivo, String estado) async{
    await _firestore.collection('dispositivos').doc(idDispositivo).update({
      'estado': estado.toLowerCase(),
    })
        .then((value) => print("Cambiado el estado del dispositivo"))
        .catchError((error) => print("Error cambiando el estado del dispositivo: $error"));
  }

  /// Returns a stream of devices without a room
  Stream<List<Device>> getDevicesInactive(){
    return _firestore.collection('dispositivos')
        .where("uid", isEqualTo: _userUid)
        .where("habitacion", isEqualTo: "").orderBy('estado')
        .where("estado", isNotEqualTo: "disconnected")
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data())).toList());
  }

  /// Returns a stream of devices within an specific room
  Stream<List<Device>> getDevicesInRoom(Room habitacion){
    return _firestore.collection('dispositivos')
        .where("uid", isEqualTo: _userUid)
        .where("habitacion", isEqualTo: habitacion.id)
        .where("estado", isNotEqualTo: "disconnected")
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data())).toList());
  }
}