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

  Stream<List<Device>> getDevicesInRoom(Room habitacion){
    print("ID de la habitacion: " + habitacion.id);
    return _firestore.collection('dispositivos').where("habitacion", isEqualTo: habitacion.id)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data()))
        .toList());
  }
}