import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../device_repository.dart';
import '../room_repository.dart';

class DeviceRepository {
  final FirebaseFirestore _firestore; // = FirebaseFirestore.instance;
  final User _user;

  DeviceRepository({
    FirebaseFirestore firestore,
    User user
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
      _user = user ?? FirebaseAuth.instance.currentUser;
  

  Stream<List<Device>> getListDeviceUnused(){}

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
    .catchError((err) => print("Error desagsinando habitacion del dispositivo: $err"));
    return desasignado;
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
        .catchError((err) => print("Error desagsinando habitacion del dispositivo: $err"));
    return asignado;
  }

  Stream<List<Device>> getDevicesInactive(){
    return _firestore.collection('dispositivos').where("uid", isEqualTo: _user.uid)
        .where("habitacion", isEqualTo: "")
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data())).toList());
  }

  Stream<List<Device>> getDevicesInRoom(Room habitacion){
    return _firestore.collection('dispositivos').where("uid", isEqualTo: _user.uid)
        .where("habitacion", isEqualTo: habitacion.id)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data())).toList());
  }
}