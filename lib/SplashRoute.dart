import 'package:flutter/material.dart';

import 'ColorScheme.dart';
import 'main.dart';

class SplashRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getDays(context);
    return Scaffold(
      backgroundColor: backgroundGeneral,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset("assets/logo.jpg"),
        ),
      ),
    );
  }
}
