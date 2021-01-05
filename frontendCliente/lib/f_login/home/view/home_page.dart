import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:frontendCliente/f_login/home/home.dart';
import 'package:frontendCliente/Widgets/home_app_bar.dart' as appbar;

class HomePage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: appbar.HomeAppBar(
        user: user,
        title: "HOME",
        gradientBegin: Colors.black87,
        gradientEnd: Colors.black87,
        gradientMid: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
          child: Column(
          children: <Widget>[
          Expanded(
            child:
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage("https://media.discordapp.net/attachments/502530393740673025/796006411527913482/hagomasquealex.jpg?width=524&height=468") //https://i.pinimg.com/736x/d1/2c/93/d12c9376d6fe2a9d33f2d1840ffae02c.jpg
                            // https://image.flaticon.com/icons/png/512/1375/1375683.png
                          )
                      ),
                      
                      child: Container(

                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "HABITACIONES",
                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                color: Colors.white,
                                blurRadius: 50.0
                              )
                            ],
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: (){

                  },
                ),
              ),
            ),
          Expanded(
            child:Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              //shadowColor: Colors.black87,

              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage("")
                    )
                  ),
                  child: Center(
                    child: Text("DISPOSITIVOS INACTIVOS"),
                  ),
                ),
              ),
            ),
          )
        ],
      ))
        /*ListView.builder(itemCount: ,
        )*/
        /*Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user.photo),
            ),
            const SizedBox(height: 4.0),
            Text(user.email, style: textTheme.headline6),
            const SizedBox(height: 4.0),
            Text(user.name ?? '', style: textTheme.headline5),
          ],
        ),*/

    );
  }
}