// import 'dart:collection';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async' as async;
// import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
// import 'Habitacion.dart';
// import 'auth.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontendCliente/app.dart';
import 'package:frontendCliente/simple_bloc_observer.dart';

//Prueba login con block
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title: 'Flutter demo login',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter demo login'),
//           backgroundColor: Colors.amber,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               LoginButton(),
//               UserProfile()
//             ],
//           ),
//         ),
//       )
//     );
//   }
// }
//
// class UserProfile extends StatefulWidget {
//   @override
//   UserProfileState createState() => UserProfileState();
// }
//
// class UserProfileState extends State<UserProfile> {
//   Map<String, dynamic> _profile;
//   bool _loading = false;
//
//   @override
//   initState() {
//     super.initState();
//
//     // Subscriptions are created here
//     authService.profile.listen((state) => setState(() => _profile = state));
//
//     authService.loading.listen((state) => setState(() => _loading = state));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
//       Text(_loading.toString())
//     ]);
//   }
// }
//
// class LoginButton extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return StreamBuilder(
//       stream: authService.user,
//       builder: (context, snapshots){
//         if(snapshots.hasData){
//           return MaterialButton(
//             onPressed: () => authService.signOut(),
//             color: Colors.red,
//             textColor: Colors.white,
//             child: Text('Signout'),
//           );
//         }
//         else{
//           return MaterialButton(
//             onPressed: () => authService.googleSignIn(),
//             color: Colors.white,
//             textColor: Colors.black,
//             child: Text('Login with Google'),
//           );
//         }
//       }
//     );
//   }
// }

//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   Map data;
//   String petData;
//
//   void getPeticiones() async {
//     http.Response response = await http.get('https://spike-domotica.herokuapp.com/peticiones/getPeticion');
//     /*if(response.statusCode == 200){
//       return Peticion.fromJson(jsonDecode(response.body));
//     }
//     else{
//     throw Exception('ha fallado el get');
//     }*/
//     data = json.decode(response.body);
//     setState(() {
//       petData = data['peticion']['name'];
//     });
//   }
//
//   @override
//   void initState(){
//     super.initState();
//     getPeticiones();
//   }
//
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Lista de peticiones'),
//           backgroundColor: Colors.white12,
//         ),
//         body: Center(
//             child: Text(petData)
//         )
//     );
//   }
// }