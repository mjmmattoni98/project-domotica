import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  void initState() {
    
    _saveDeviceToken();
    _fcm.configure(
      //app in the foreground
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      //
      onBackgroundMessage: myBackgroundMessageHandler,
      //app in the background
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      //app terminated
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  // Get the token, save it to the database for current user
  Future<void> _saveDeviceToken() async {
    // Get the current user
    User user = _auth.currentUser;
    String uid = user.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    CollectionReference tokens = _db.collection('users').doc(uid).collection('tokens');

     // Save it to Firestore
    if (fcmToken != null) {
      return tokens.doc(fcmToken).set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      }).then((value) => print("Token added"))
          .catchError((error) => print("Failed to add token: $error"));
    }
  }

}



