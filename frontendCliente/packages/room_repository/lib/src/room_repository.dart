
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../device_repository.dart';
import '../room_repository.dart';

class RoomRepository{
  final FirebaseFirestore _firestore;// = FirebaseFirestore.instance;
  final User _user;
  //final User currUser = FirebaseAuth.instance.currentUser;

  RoomRepository({
    FirebaseFirestore firestore,
    User user
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
      _user = user ?? FirebaseAuth.instance.currentUser;

  Stream<List<Room>> getRoomList() {
    return _firestore.collection('habitaciones')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Room.fromJson(document.data()))
        .toList());
  }

  Future<void> changeName(Room habitacion, String nombreNuevo){
    return _firestore.collection('habitaciones').doc(habitacion.id).update({
      "nombre": nombreNuevo
    });
  }


  Future<List<Room>> getRoomListAct() async {
    Stream<List<Room>> s = _firestore.collection('habitaciones')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Room.fromJson(document.data()))
        .toList());
    return s.first;
  }
  
  Future<void> createRoom(String nombre){
    return _firestore.collection('habitaciones').add({
      "nombre": nombre,
      "uid": _user.uid,
      "id": "",
    }).then((value) => value.update({
      "id": value.id,
    }));
  }

  Future<void> deleteRoom(Room habitacion){
    return _firestore.collection('habitaciones').doc(habitacion.id).delete();
  }
}