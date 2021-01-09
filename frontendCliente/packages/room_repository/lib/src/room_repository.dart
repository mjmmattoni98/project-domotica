import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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




  //Stream<List<Room>> get rooms{
    /*_firestore.collection('room').snapshots()
    return _firestore.collection("room").snapshots().map((snapshot) => return snapshot.docs.map((doc) => Room.fromSnapshot))
    _firestore.collection('rooms').doc(currUser.uid);*/
  Stream<List<Room>> getRoomList() {
    return _firestore.collection('habitacion')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Room.fromJson(document.data()))
        .toList());
  }

  /*Future<Stream<Room>> getRoom() async {
    Stream<Map<String, dynamic>> ref = _firestore.collection('habitacion').doc('hBueqmdbXEIyIr8Uwjqz').snapshots().map((snap) => snap.data());
    return Stream.value(Room.fromJson(await ref.single));
  }*/
  //}
}