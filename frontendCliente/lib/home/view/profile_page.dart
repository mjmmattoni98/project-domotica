import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontendCliente/f_login/authentication/authentication.dart';
import 'package:authentication_repository/authentication_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final defaultURL = "https://drive.google.com/uc?id=1CHpt2mxANOKcmx-3ojtdUbeEN2ZIiap6";
    final User user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(user.name ?? ""),
          subtitle: Text(user.email ?? ""),
        ),
        leading: CircleAvatar(
            radius: 22.0,
            child: ClipOval(
                child: new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image.network(user.photo ?? defaultURL, fit: BoxFit.fill),
                )
            )
        ),
        actions: <Widget>[
          IconButton(
            // key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.clear_rounded),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 40.0),
          _AyudaYComentariosButton(),
          const SizedBox(height: 8.0),
          _AcercaDeButton(),
          const SizedBox(height: 15.0),
          _EliminarCuenta(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Boton para cerrar sesión
        onPressed: () => context
            .read<AuthenticationBloc>()
            .add(AuthenticationLogoutRequested()),
        tooltip: "Log out",
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}

class _AyudaYComentariosButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: const Text("Ayuda y comentarios"),
      onPressed: null,
    );
  }
}

class _AcercaDeButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: const Text("Acerca de"),
      onPressed: null,
    );
  }
}

class _EliminarCuenta extends StatelessWidget{
  final String textTitle = "Para eliminar la cuenta, primero tienes que cerrar sesión y volver a entrar en la aplicación.";
  final String textContent = "Si ya has hecho este paso, apreta en el botón de aceptar. "
      "Si no lo has hecho, por favor apreta en cancelar y realiza el proceso";

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: const Text("Eliminar cuenta",
        style: TextStyle(
          fontFamily: "Raleway",
          color: Colors.red,
        ),
      ),
      onPressed: () => showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 10.0,
              title: Text(textTitle,
                style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 20.0,
                ),
              ),
              content: Text(textContent,
                style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 15.0,
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 10.0,
                  onPressed: () {
                    context.read<AuthenticationBloc>()
                        .add(AuthenticationDeleteAccountRequested());
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.check),
                ),
                MaterialButton(
                  elevation: 10.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.clear_rounded),
                )
              ],
            );
          }
      ),
    );
  }
}