import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    firebase_auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FirebaseMessaging firebaseMessaging,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _fcm = firebaseMessaging ?? FirebaseMessaging(),
        super(){
          _tokenSubscription = _fcm.onTokenRefresh.listen(_saveDeviceToken);
        }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _fcm;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription _tokenSubscription;


  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
        return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
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
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebase_auth.User user = (await _firebaseAuth.signInWithCredential(credential)).user;
      updateUserData(user);
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
      firebase_auth.User user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      updateUserData(user);
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

  void updateUserData(firebase_auth.User user) async{
    DocumentReference ref = _db.collection('users').doc(user.uid);
    String fcmToken = await _fcm.getToken();

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': user.photoURL,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, SetOptions(merge: true))
    .then((value) => _saveDeviceToken(fcmToken))
    .catchError((error) => print("Failed while updating user: $error"));
  }

  Future<void> _saveDeviceToken(String token) async {
    // Get the current user
    String uid = _firebaseAuth.currentUser.uid;

    CollectionReference tokens = _db.collection('users').doc(uid).collection('tokens');

    // Save it to Firestore
    if (token != null) {
      return tokens.doc(token).set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      }).then((value) => print("Token added"))
          .catchError((error) => print("Failed to add token: $error"));
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
