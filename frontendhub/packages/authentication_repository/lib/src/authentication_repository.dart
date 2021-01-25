import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// Thrown during the delete account process if a failure occurs.
class DeleteAccountFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _db;

  /// Stream of [Hub] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [Hub.empty] if the user is not authenticated.
  Stream<Hub> get hub {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? Hub.empty : firebaseUser.toHub;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      updateHubData(user);
    } on Exception catch (e){
      print("Error sign up: $e");
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      User user = (await _firebaseAuth.signInWithCredential(credential)).user;
      updateHubData(user);
    } on Exception catch (e){
      print("Error log in with google: $e");
      throw LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      updateHubData(user);
    } on Exception catch (e){
      print("Error error log in with email and password: $e");
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [Hub.empty] from the [hub] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception catch (e){
      throw LogOutFailure();
    }
  }

  /// Deletes the current user account which will emit
  /// [Hub.empty] from the [hub] Stream.
  ///
  /// Throws a [DeleteAccountFailure] if an exception occurs.
  Future<void> deleteAccount() async {
    try {
      String uid = _firebaseAuth.currentUser.uid;
      await Future.wait([
        _firebaseAuth.currentUser.delete(),
        _deleteAllInformation(uid),
        ]);
    } on Exception catch (e){
      if(e is FirebaseAuthException && e.code == "requires-recent-login")
        print("El usuario tiene que reautenticarse para eliminar la cuenta");
      throw DeleteAccountFailure();
    }
  }

  /// Elimina toda la informacion del usuario de la base de datos
  Future<void> _deleteAllInformation(String uid) async{
    //Eliminamos al usuario de la coleccion de users
    await _db.collection('users').doc(uid).delete();

    //Eliminamos al usuario de la coleccion de hubs
    await _db.collection('hubs').doc(uid).delete();

    //Eliminamos todas las habitaciones del usuario
    await _db.collection('habitaciones')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) => doc.reference.delete())
        });

    //Eliminamos todos los dispositivos del usuario
    await _db.collection('dispositivos')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) => doc.reference.delete())
        });
  }

  Future<void> updateStateHub(String uid){
    DocumentReference ref = _db.collection('hubs').doc(uid);

    return ref.update({
      'estado': "pong"
    })
    .then((value) => print("Actualizado el estado del hub"))
    .catchError((error) => print("Error al intentar actualizar el estado del hub: $error"));
  }

  Future<void> updateHubData(User user){
    DocumentReference ref = _db.collection('hubs').doc(user.uid);

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'consultas': 0,
      'estado': "pong"
    }, SetOptions(merge: true))
    .then((value) => print("Hub actualizado con exito"))
    .catchError((error) => print("Error actualizando hub: $error"));
  }
}

extension on User {
  Hub get toHub {
    return Hub(uid: uid, email: email, name: displayName, consultas: 0, estado : "pong", photo: photoURL);
  }
}
