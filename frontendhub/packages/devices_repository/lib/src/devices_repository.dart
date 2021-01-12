import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'models/models.dart';

/// {@template device_repository}
/// Repository which manages user devices.
/// {@endtemplate}
class DeviceRepository {
  /// {@macro device_repository}
  DeviceRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<String> get hubUid {
    return _auth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? "" : firebaseUser.uid;
    });
  }

  Future<List<Device>> getDevices(String uid) async{
    List<Device> dispositivos = [];

    await _db.collection('dispositivo')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if(doc.exists){
              dispositivos.add(Device.fromJson(doc.data(), doc.id));
            }
          })
        })
        .catchError((error) => print("Error obteniendo los nombres de los dispositivos: $error"));
    return dispositivos;
  }

  Future<void> updateDeviceState(String uid, String name, String estado) async{
    await _db.collection('dispositivo')
        .where('uid', isEqualTo: uid)
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

  Future<void> updateDeviceName(String uid, String lastName, String newName) async{
     await _db.collection('dispositivo')
         .where('uid', isEqualTo: uid)
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

  void createDevice(Device device, String uid) async{
    CollectionReference ref = _db.collection('dispositivo');

    return ref.add({
      'estado': device.estadoActual.toLowerCase(),
      'tipo': device.nombreTipo.toLowerCase(),
      'habitacion': "",
      'nombre': device.name.toLowerCase(),
      'uid': uid,
    }).then((value) => print("Dispositivo creado"))
      .catchError((error) => print("Error creando dispositivo: $error"));
  }

  Future<void> deleteDevice(String uid, String name) async{
    await _db.collection('dispositivo')
        .where('uid', isEqualTo: uid)
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
}
