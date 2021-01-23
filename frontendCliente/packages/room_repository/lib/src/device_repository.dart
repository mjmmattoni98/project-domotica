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

  Future<void> desasignacionDispositivos(String nuevoDispositivos, Room habitacion, String idDispositivo) async {
      await _firestore.collection('habitaciones').doc(habitacion.id).update({
      "dispositivos": nuevoDispositivos
    }); // primero eliminamos el dispositivo de la habitacion
      return _firestore.collection('dispositivos').doc(idDispositivo).update(
          {
            "habitacion" : ""
          }); // despues eliminamos la habitacion del dispositivo
  }

  Stream<List<Device>> getDevicesInRoom(Room habitacion){
    return _firestore.collection('dispositivos').where("uid", isEqualTo: _user.uid)
        .where("habitacion", isEqualTo: habitacion.id)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data()))
        .toList());
  }
}