import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'models/models.dart';

/// {@template device_repository}
/// Repository which manages user devices.
/// {@endtemplate}
class DeviceRepository {
  /// {@macro device_repository}
  DeviceRepository({
    FirebaseFirestore firestore,
    FirebaseAuth auth,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get _userUid => _auth.currentUser.uid;

  Stream<List<Device>> getDevices() {
    return _db.collection('dispositivos')
        .where('uid', isEqualTo: _userUid)
        .snapshots()
        .map((snapshots) {
          return snapshots.docs
              .map((document) => Device.fromJson(document.data()))
              .toList();
    });
  }

  Future<List<Device>> getDevicesAct() async {
    return await _db.collection('dispositivos')
        .where('uid', isEqualTo: _userUid)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Device.fromJson(document.data()))
        .toList()).first;
  }

  Future<void> updateDeviceState(String name, String estado) async{
    await _db.collection('dispositivos')
        .where('uid', isEqualTo: _userUid)
        .where('nombre', isEqualTo: name.toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if(doc.exists){
              doc.reference.update({
                'estado': estado.toLowerCase(),
              });
            }
          })
        })
        .catchError((error) => print("Error cambiando el estado del dispositivo: $error"));
  }

  Future<void> updateDeviceName(String lastName, String newName) async{
    await _db.collection('dispositivos')
         .where('uid', isEqualTo: _userUid)
         .where('nombre', isEqualTo: lastName.toLowerCase())
         .get()
          .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              if(doc.exists){
                doc.reference.update({
                  'nombre': newName.toLowerCase(),
                });
              }
            })
          })
          .catchError((error) => print("Error cambiando el nombre del dispositivo: $error"));
  }

  Future<void> createDevice(Device device) async{
    CollectionReference ref = _db.collection('dispositivos');

    await ref.add({
      'estado': device.estadoActual.toLowerCase(),
      'tipo': device.nombreTipo.toLowerCase(),
      'habitacion': "",
      'nombre': device.name.toLowerCase(),
      'uid': _userUid,
      'id': "",
    }).then((value) => value.update({
      'id': value.id,
    }))
      .catchError((error) => print("Error creando dispositivo: $error"));
  }

  Future<void> deleteDevice(String name) async{
    await _db.collection('dispositivos')
        .where('uid', isEqualTo: _userUid)
        .where('nombre', isEqualTo: name.toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if(doc.exists){
              doc.reference.delete();
            }
          })
        })
        .catchError((error) => print("Error eliminando dispositivo: $error"));
  }
  
  Future<void> createDefaultDevices() async{
    Device alarma = Device(name: "alarmaDefualt", tipo: TipoDispositivo.ALARMA);
    await createDevice(alarma);
    Device movimiento = Device(name: "movimientoDefualt", tipo: TipoDispositivo.DETECTOR_DE_MOVIMIENTO);
    await createDevice(movimiento);
    Device apertura = Device(name: "aperturaDefault", tipo: TipoDispositivo.SENSOR_DE_APERTURA);
    await createDevice(apertura);
  }
}
