import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendCliente/home/home.dart';
import 'package:authentication_repository/authentication_repository.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{

  final double _prefferedHeight = 125.0;
  final String title;
  final Color gradientBegin, gradientEnd, gradientMid;
  final User user;
  final defaultURL = "https://drive.google.com/uc?id=1CHpt2mxANOKcmx-3ojtdUbeEN2ZIiap6";

  HomeAppBar({this.title, this.user, this.gradientBegin, this.gradientEnd, this.gradientMid}) :
      assert(title != null),
      assert(user != null),
      assert(gradientEnd != null),
      assert(gradientBegin != null),
      assert(gradientMid != null);

  @override
  Widget build(BuildContext context) {
    // final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

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
                  FlatButton(
                    key: const Key('homePage_avatar_profile_user'),
                    child: CircleAvatar(
                        radius: 22.0,
                        child: ClipOval(
                            child: new SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: Image.network(user.photo ?? defaultURL, fit: BoxFit.fill),
                            )
                        )
                    ),
                    onPressed: () => Navigator.of(context).push<void>(ProfilePage.route()),
                  ),
                ]
              )
            )
        )
      );
  }
  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}