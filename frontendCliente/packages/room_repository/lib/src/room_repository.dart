import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../device_repository.dart';
import '../room_repository.dart';

/// {@template room_repository}
/// Repository which manages user rooms.
/// {@endtemplate}
class RoomRepository{
  /// {@macro device_repository}
  RoomRepository({
    FirebaseFirestore firestore,
    FirebaseAuth auth
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userUid => _auth.currentUser.uid;

  Stream<List<Room>> getRoomList() {
    return _firestore.collection('habitaciones')
        .where("uid", isEqualTo: _userUid)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Room.fromJson(document.data()))
        .toList());
  }

  // Stream<List<Room>> getRoomListAct() {
  //   return _firestore.collection('habitaciones')
  //       .snapshots()
  //       .map((snapShot) => snapShot.docs
  //       .map((document) => Room.fromJson(document.data()))
  //       .toList());
  //
  // }

  Future<void> changeName(Room habitacion, String nombreNuevo){
    return _firestore.collection('habitaciones').doc(habitacion.id).update({
      "nombre": nombreNuevo
    })
    .then((value) => print("Cambiado nombre de la habitacion con exito"))
        .catchError((err) => print("Error cambiando el nombre de la habitacion: $err"));
  }

  Future<void> createRoom(String nombre){
    return _firestore.collection('habitaciones').add({
      "nombre": nombre,
      "uid": _userUid,
      "id": "",
      "activo": false,
    })
        .then((value) => value.update({
          "id": value.id,
        }))
    .catchError((err) => print("Error creando la habitacion: $err"));
  }

  Future<void> deleteRoom(Room habitacion){
    return _firestore.collection('habitaciones').doc(habitacion.id).delete()
    .then((value) => print("Habitacion eliminada con exito"))
        .catchError((err) => print("Error eliminando la habitacion: $err"));
  }
}