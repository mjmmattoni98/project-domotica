import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendhub/f_home/home.dart';
import 'package:frontendhub/f_login/authentication/authentication.dart';
import 'package:devices_repository/devices_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:frontendhub/f_dispositivos/dispositivos.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final defaultURL = "https://drive.google.com/uc?id=1CHpt2mxANOKcmx-3ojtdUbeEN2ZIiap6";
    final hub = context.select((AuthenticationBloc bloc) => bloc.state.hub);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
          ),
        ],
      ),
      body: RepositoryProvider.value(
        value: GetIt.I<DeviceRepository>(), // Singleton instance of the DeviceRepository
        child: BlocProvider(
          create: (_) => DispositivosBloc(
            deviceRepository: GetIt.I<DeviceRepository>(), // Singleton instance of the DeviceRepository
          ),
          child: ListadoDispositivosPage(),
        ),
      ),
    );
  }
}
