import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
//import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{

  final double _prefferedHeight = 125.0;
  final String title;
  final Color gradientBegin, gradientEnd, gradientMid;

  HomeAppBar({this.title, this.gradientBegin, this.gradientEnd, this.gradientMid}) :
      assert(title != null),
      assert(gradientEnd != null),
      assert(gradientBegin != null),
      assert(gradientMid != null);


  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    //final User user = firebase_auth.User as User;


    //final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
      return Container(
          height: _prefferedHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              gradientBegin,
              gradientMid,
              gradientEnd
            ]
          )
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.menu, size: 37.0, color: Colors.white70,),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Raleway",
                      shadows: <Shadow>[
                        Shadow(
                          color: Colors.black,
                          blurRadius: 50.0,
                        )
                      ],
                      color: Colors.white70,
                      letterSpacing: 3.0,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  CircleAvatar(
                    radius: 22.0,
                    child: ClipOval(
                        child: new SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: new Image.network(user.photoURL, fit: BoxFit.fill),
                        )
                    )
                    //backgroundImage: NetworkImage(user.photo),
                  )
                ]
              )
            )
        )
      );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(_prefferedHeight);

}