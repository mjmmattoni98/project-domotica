import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendhub/f_home/view/profile_page.dart';
import 'package:frontendhub/f_login/authentication/authentication.dart';
import 'package:frontendhub/f_home/home.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final defaultURL = "https://drive.google.com/uc?id=19hiUSohFDHZTi0k6QZeipLbzNHC0juLX";
    final textTheme = Theme.of(context).textTheme;
    final hub = context.select((AuthenticationBloc bloc) => bloc.state.hub);
    bool isSwitched = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        // leading: Switch(
        //   value: isSwitched,
        //   onChanged: (value) => {
        //     isSwitched = value;
        //   },
        //   activeColor: Colors.green,
        // ),
        actions: <Widget>[
          FlatButton(
            key: const Key('homePage_avatar_profile_user'),
            child: CircleAvatar(
                radius: 22.0,
                child: ClipOval(
                    child: new SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Image.network(hub.photo ?? defaultURL, fit: BoxFit.fill),
                    )
                )
            ),
            onPressed: () => Navigator.of(context).push<void>(ProfilePage.route()),
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
                radius: 22.0,
                child: ClipOval(
                    child: new SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Image.network(hub.photo ?? defaultURL, fit: BoxFit.fill),
                    )
                )
            ),
            const SizedBox(height: 4.0),
            Text(hub.email ?? "", style: textTheme.headline6),
          ],
        ),
      ),
    );
  }
}