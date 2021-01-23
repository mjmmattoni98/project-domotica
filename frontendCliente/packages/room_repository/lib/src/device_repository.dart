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

  Future<void> desasignacionDispositivos(String idDispositivo) async {
      return _firestore.collection('dispositivos').doc(idDispositivo).update(
          {
            "habitacion" : ""
          }); // eliminamos la habitacion del dispositivo
  }

  Future<void> asingacionDispositivos(String idDispositivo, String idHabitacion){
    return _firestore.collection('dispositivos').doc(idDispositivo).update({
      "habitacion" : idHabitacion
    });
  }

  Stream<List<Device>> getDevicesInRoom(Room habitacion){
    return _firestore.collection('dispositivos').where("uid", isEqualTo: _user.uid)
        .where("habitacion", isEqualTo: habitacion.id)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data())).toList());
  }
}