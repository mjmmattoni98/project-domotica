import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/trio_de_la_muerte.jpg',
          key: const Key('splash_bloc_image'),
          width: 150,
        ),
      ),
    );
  }
}