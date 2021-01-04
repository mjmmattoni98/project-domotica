import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  final User user;
  final double _prefferedHeight = 125.0;
  final String title;
  final Color gradientBegin, gradientEnd, gradientMid;

  HomeAppBar({this.user, this.title, this.gradientBegin, this.gradientEnd, this.gradientMid}) :
      assert(user != null),
      assert(title != null),
      assert(gradientEnd != null),
      assert(gradientBegin != null),
      assert(gradientMid != null);


  @override
  Widget build(BuildContext context) {
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
                        child: new Image.network(user.photo, fit: BoxFit.fill),
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