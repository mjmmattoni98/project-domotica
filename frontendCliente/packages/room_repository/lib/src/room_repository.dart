

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../room_repository.dart';

class RoomRepository{



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User currUser = FirebaseAuth.instance.currentUser;


  /*Stream<List<Room>> get rooms{
    _firestore.collection('room').snapshots()
    return _firestore.collection("room").snapshots().map((snapshot) => return snapshot.docs.map((doc) => Room.fromSnapshot))
    _firestore.collection('rooms').doc(currUser.uid);

  }*/

}