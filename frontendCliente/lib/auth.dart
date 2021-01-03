import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';


class AuthService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User> user;
  Stream<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService(){
    user = _auth.authStateChanges().asBroadcastStream();
    profile = user.switchMap((User u) {
      if(u != null){
        return _db.collection('users').doc(u.uid).snapshots().map((snap) => snap.data()).asBroadcastStream();
      }
      else{
        return Stream.empty().asBroadcastStream();
      }
    });
  }

  Future<User> googleSignIn() async{
    // createFirebaseApp();
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User userRegistered = (await _auth.signInWithCredential(credential)).user;

    updateUserData(userRegistered);
    print("Signed in " + userRegistered.displayName);

    loading.add(false);
    return userRegistered;

  }

  void updateUserData(User user) async{
    DocumentReference ref = _db.collection('users').doc(user.uid);

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': user.photoURL,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, SetOptions(merge: true));
  }

  void signOut(){
    _auth.signOut();
  }
}

final AuthService authService = AuthService();
