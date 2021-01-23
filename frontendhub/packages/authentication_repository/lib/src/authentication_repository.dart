import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
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

  Future<void> updateStateHub(String uid){
    DocumentReference ref = _db.collection('hubs').doc(uid);

    return ref.update({
      'estado': "pong"
    }).then((value) => print("Actualizado el estado del hub"))
        .catchError((error) => print("Error al intentar actualizar el estado del hub: $error"));
        
  }

  void updateHubData(User user) async{
    DocumentReference ref = _db.collection('hubs').doc(user.uid);

    await ref.set({
      'uid': user.uid,
      'email': user.email,
      'consultas': 0,
      'estado': "pong"
    }, SetOptions(merge: true))
    .then((value) => print("Hub updated"))
    .catchError((error) => print("Failed while updating hub: $error"));
  }
}

extension on User {
  Hub get toHub {
    return Hub(id: uid, email: email, name: displayName, consultas: 0, estado : "pong", photo: photoURL);
  }
}
